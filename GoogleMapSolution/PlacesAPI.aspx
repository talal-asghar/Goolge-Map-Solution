<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlacesAPI.aspx.cs" Inherits="PlacesAPI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .MapPlaceHolder {
            width: 600px;
            height: 600px;
            float: right;
        }

        .SearchResult {
            float: left;
            width: 900px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&language=en&libraries=places"></script>
    <script src="Resources/js/Maps.js"></script>
    <script>

        function SearchFromQuery() {
            debugger
            document.getElementById('results').innerHTML = "";
            var lat = parseFloat($('#latitude').val());
            var long = parseFloat($('#longitude').val());
            var radius = parseInt($('#radius').val());
            var location = new google.maps.LatLng(lat, long);


            var container = $('.PlaceSearchContainer');
            var textValue = $('#textSearch').val();
            var service = new google.maps.places.PlacesService(container.get(0));


            var request = {
                locationBias: { radius: radius, center: location },
                query: textValue,
                fields: ['formatted_address', 'geometry']
            };

            service.findPlaceFromQuery(request, OnResultFoundQuery);
        }

        function TextSearch() {
            debugger
            document.getElementById('results2').innerHTML = "";
            var lat = parseFloat($('#latitude').val());
            var long = parseFloat($('#longitude').val());
            var radius = parseInt($('#radius').val());
            var location = new google.maps.LatLng(lat, long);


            var container = $('.PlaceSearchContainer');
            var textValue = $('#textSearch').val();
            var service = new google.maps.places.PlacesService(container.get(0));
            var request = {
                location: location,
                radius: radius,
                query: textValue
            };

            service.textSearch(request, OnResultFoundText);
        }

        function OnResultFoundQuery(results, status) {
            debugger
            if (status == google.maps.places.PlacesServiceStatus.OK) {

                let results_html = [];
                for (var i = 0; i < results.length; i++) {
                    results_html.push(`<li>${results[i].formatted_address}<span>-----${results[i].geometry.location}</span><input type='button' value='Navigate' onclick='LoadMapWithCoordinates(${results[i].geometry.location.lat()},${results[i].geometry.location.lng()})' /></li>`);
                }
                document.getElementById('results').innerHTML = results_html.join("");
            }
        }

        function OnResultFoundText(results, status) {
            debugger
            if (status == google.maps.places.PlacesServiceStatus.OK) {

                let results_html = [];
                for (var i = 0; i < results.length; i++) {
                    results_html.push(`<li>${results[i].formatted_address}<span>-----${results[i].geometry.location}</span><input type='button' value='Navigate' onclick='LoadMapWithCoordinates(${results[i].geometry.location.lat()},${results[i].geometry.location.lng()})' /></li>`);
                }
                document.getElementById('results2').innerHTML = results_html.join("");
            }
        }

        function GeoCodeAddress() {
            debugger
            var lat = parseFloat($('#latitude').val());
            var long = parseFloat($('#longitude').val());
            var coordinates = new google.maps.LatLng(lat, long);

            var textValue = $('#textSearch').val();

            GoogleMapAPI.initializeMap();
            GoogleMapAPI.setMapNewCenter(coordinates);
            GoogleMapAPI.map.setZoom(13);
            GoogleMapAPI.geoCodeAddressWithBounds(textValue, GoogleMapAPI.circles[0].getBounds(), GeoCodeResponse_VerifyBounds);
        }

        function GetPlacePredictions() {
            debugger
            document.getElementById('results3').innerHTML = "";

            var textValue = $('#textSearch').val();
            var bounds = GetBounds();

            let service = new google.maps.places.AutocompleteService();
            var options = {
                bounds: bounds,
                strictBounds: true,
                input: textValue,
                componentRestrictions: { country: 'AE' }
            }

            service.getPlacePredictions(options, OnPlacePredictionSearch);
        }

        function OnPlacePredictionSearch(predictions, status) {

            debugger
            if (status == google.maps.places.PlacesServiceStatus.OK) {

                let results_html = [];

                predictions.forEach(function (prediction) {
                    debugger

                    GetCoordinatesByPlaceId(prediction.place_id, function (place, status) {
                        {
                            debugger
                            if (status == google.maps.places.PlacesServiceStatus.OK) {
                                var coordinates = GetCoordinates();
                                var radius = parseInt($('#radius').val());
                                var isInsideBound = IsLocationInsideCircle(place.geometry.location, coordinates, radius / 1000);
                                // if (isInsideBound)
                                document.getElementById('results3').innerHTML = document.getElementById('results3').innerHTML + `<li>${prediction.structured_formatting.main_text}<span>-----${place.geometry.location}</span><input type='button' value='Navigate' onclick='LoadMapWithCoordinates(${place.geometry.location.lat()},${place.geometry.location.lng()})' /></li>`;
                            }
                        }
                    });
                });
            }
        }

        function GetCoordinatesByPlaceId(placeId, callback) {
            var request = {
                placeId: placeId,
                fields: ['geometry']
            };

            var container = $('.PlaceSearchContainer');
            let service = new google.maps.places.PlacesService(container.get(0));
            service.getDetails(request, callback);
        }

        function GetBounds() {

            var radius = parseInt($('#radius').val());
            var coordinates = GetCoordinates();

            const circle = new google.maps.Circle({
                center: coordinates,
                radius: radius, // IN METERS.
                fillColor: '#FF6600',
                fillOpacity: 0.3,
                strokeColor: "#FFF",
                clickable: true,
                strokeWeight: 0 // DON'T SHOW CIRCLE BORDER.
            });

            return circle.getBounds();
        }

        function GetCoordinates() {
            var lat = parseFloat($('#latitude').val());
            var long = parseFloat($('#longitude').val());
            var coordinates = new google.maps.LatLng(lat, long);
            return coordinates;
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="SearchResult">
            <input type="text" id="textSearch" value="" placeholder="Enter Text" /><br />
            <input type="text" id="latitude" value="25.2201105" placeholder="Latitude" />
            <input type="text" id="longitude" value="55.2563077" placeholder="Longitude" />
            <input type="text" class="inpCircleRadius" id="radius" value="3000" placeholder="Radius" />

            <input type="button" onclick="SearchFromQuery()" value="Place Search" />
            <input type="button" onclick="TextSearch()" value="Fuzzy Search" />
            <input type="button" onclick="GetPlacePredictions()" value="Get Predictions" />
            <input type="button" onclick="GeoCodeAddress()" value="Geocode Address" />


            <div class="PlaceSearchContainer"></div>
            <br />
            <br />
            <div>
                <h3>Query search</h3>
                <ul id="results"></ul>
            </div>
            <div>
                <h3>Text Search</h3>
                <ul id="results2"></ul>
            </div>
            <div>
                <h3>Place Predictions Search</h3>
                <ul id="results3"></ul>
            </div>
        </div>
        <div class="MapPlaceHolder"></div>
    </form>
</body>
</html>
