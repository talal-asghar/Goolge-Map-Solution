<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AllAutocompleteTypesTest.aspx.cs" Inherits="Default3" %>

<!DOCTYPE html>
<html>
<head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
    <style>
        /* Set the size of the div element that contains the map */
        #map {
            height: 400px; /* The height is 400 pixels */
            width: 100%; /* The width is the width of the web page */
        }
    </style>


</head>

<body>
<%--    <img src="https://maps.googleapis.com/maps/api/staticmap?center=25.14,55.18&zoom=15&size=400x400&markers=color:RED%7Clabel:PIN%7C25.14,55.18&key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs" />--%>
    <h3>My Google Maps Demo</h3>
    <!--The div element for the map -->
    <div id="map"></div>
  
    <!--Load the API from the specified URL
    * The async attribute allows the browser to render the page while the API loads
    * The key parameter will contain your own API key (which is not needed for this tutorial)
    * The callback parameter executes the initMap() function
    -->

    <%--        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&callback=initMap">    </script>--%>


    <input id="searchTextField" type="text" size="50" placeholder="Anything you want!">
    <input type="text" id="inpMap" />
    <input type="button" onclick="AutoComplete()" value="Search Auto Complete" />
    <input type="button" onclick="SearchField()" value="Search Fields" />
    <input type="button" onclick="GetPredictions()" value="Get Predictions" />
    <input type="button" onclick="SearchAutoComplete2()" value="Search Auto Complete 2" />
    <ul id="results">
    </ul>
    <div id="locationField">
        <input
            id="autocomplete"
            placeholder="Enter your address"
            onfocus="geolocate()"
            type="text" />
    </div>
    <div id="searchResult"></div>
    <input type="text" id="searchFieldAutoComplete" placeholder="Autocomplete Search" />

      <script>
        // Initialize and add the map
        function initMap() {
            debugger
            // The location of Uluru
            var uluru = { lat: 25.14, lng: 55.18 };
            // The map, centered at Uluru
            var map = new google.maps.Map(
                document.getElementById('map'), { zoom: 8, center: uluru });
            // The marker, positioned at Uluru
            var marker = new google.maps.Marker({ position: uluru, map: map });
            initAutocomplete();

            //google.maps.event.addListener(marker, 'click', function () {

            //    alert('Hi');
            //    infowindow.open(map, this);
            //    map.setZoom(8);
            //});
//            SearchField();
            google.maps.event.addListener(map, 'click', function (event) {
                debugger;
                //alert('clicked');
                //map.setZoom(10);

                var infoWindow = new google.maps.InfoWindow(
                      { content: 'Click the map to get Lat/Lng!', position: uluru });
                infoWindow.open(map);

                infoWindow.close();

                // Create a new InfoWindow.
                infoWindow = new google.maps.InfoWindow({ position: event.latLng });
                infoWindow.setContent(event.latLng.toString());
                //map.setZoom(12);
                infoWindow.open(map);
                marker = new google.maps.Marker({
                    position: event.latLng,
                    map: map
                });

                document.getElementById('inpMap').value=event.latLng;

                //var geocoder = new google.maps.Geocoder();

                //geocoder.geocode({ 'latLng': event.latLng }, function (items, status) {
                //    debugger
                //    if (status == google.maps.GeocoderStatus.OK) {
                //        $('#latitude').val(items[0].geometry.location.lat().toString().substr(0, 12));
                //        $('#longitude').val(items[0].geometry.location.lng().toString().substr(0, 12));
                //        map.setZoom(8);
                //        marker = new google.maps.Marker({
                //            position: event.latLng,
                //            map: map
                //        });

                //        var ll = event.latLng;
                //        infowindow.setContent(ll.toString());
                //        infowindow.open(map, marker);

                //    }

                //});

            });
        }

        let placeSearch;
        let autocomplete;
        const componentForm = {
            street_number: "short_name",
            route: "long_name",
            locality: "long_name",
            administrative_area_level_1: "short_name",
            country: "long_name",
            postal_code: "short_name"
        };

        function AutoComplete() {

            debugger
            autocomplete = new google.maps.places.Autocomplete(
   document.getElementById("autocomplete"),
   { types: ["geocode"] }
 );
            // Avoid paying for data that you don't need by restricting the set of
            // place fields that are returned to just the address components.
            autocomplete.setFields(["address_component"]);
            // When the user selects an address from the drop-down, populate the
            // address fields in the form.
            autocomplete.addListener("place_changed", fillInAddress);
        }

        function fillInAddress() {
            debugger
            // Get the place details from the autocomplete object.
            const place = autocomplete.getPlace();

            for (const component in componentForm) {
                document.getElementById(component).value = "";
                document.getElementById(component).disabled = false;
            }

            // Get each component of the address from the place details,
            // and then fill-in the corresponding field on the form.
            for (const component of place.address_components) {
                const addressType = component.types[0];

                if (componentForm[addressType]) {
                    const val = component[componentForm[addressType]];
                    document.getElementById(addressType).value = val;
                }
            }
        }




        function SearchField()
        {
            debugger
            var defaultBounds = new google.maps.LatLngBounds(
              new google.maps.LatLng(25.14, 55.18),
              new google.maps.LatLng(25.14, 55.18));

            var input = document.getElementById('searchTextField');

            var options = {
                bounds:defaultBounds,
                types: ['(establishment)'],
                componentRestrictions: {country: 'AE'},
                strictBounds: true
            };

            var searchBox = new google.maps.places.SearchBox(input, options);
        }

        function GetPredictions()
        {
            var displaySuggestions = function (predictions, status) {
                if (status != google.maps.places.PlacesServiceStatus.OK) {
                    alert(status);
                    return;
                }

                predictions.forEach(function (prediction) {
                    var li = document.createElement('li');
                    li.appendChild(document.createTextNode(prediction.description));
                    document.getElementById('results').appendChild(li);
                });
            };

            var service = new google.maps.places.AutocompleteService();
            service.getQueryPredictions({ input: 'business central dubai' }, displaySuggestions);
        }

        function SearchAutoComplete2(){
            debugger
            var defaultBounds = new google.maps.LatLngBounds(
          new google.maps.LatLng(25.14, 55.18),
              new google.maps.LatLng(55.18, 55.18));

            var input = document.getElementById('searchTextField');
            var options = {
                bounds: defaultBounds
            };

            autocomplete = new google.maps.places.Autocomplete(input, options);

            document.getElementById('searchResult').innerHTML=JSON.stringify(autocomplete);
        }

        function initAutocomplete() {
            debugger

            var defaultBounds = new google.maps.LatLngBounds(
          new google.maps.LatLng(25.14, 55.18),
          new google.maps.LatLng(25.14, 55.18));


            var options = {
                bounds:defaultBounds,
                types: ['(establishment)'],
                componentRestrictions: {country: 'AE'},
                strictBounds: true
            };
            // Create the search box and link it to the UI element.
            const input = document.getElementById("searchFieldAutoComplete");
            const searchBox = new google.maps.places.SearchBox(input,options);
            //            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
            // Bias the SearchBox results towards current map's viewport.
            //          map.addListener("bounds_changed", () => {
            //            searchBox.setBounds(map.getBounds());
            //      });
            //            let markers = [];
            // Listen for the event fired when the user selects a prediction and retrieve
            // more details for that place.
            searchBox.addListener("places_changed", () => {
                debugger
                const places = searchBox.getPlaces();
                debugger
                places.forEach(place => {
                   
                    console.log( place.geometry.location);
                });
            });
        }
        //                if (places.length == 0) {
        //                    return;
        //                }
        //                // Clear out the old markers.
        ////                markers.forEach(marker => {
        //                    marker.setMap(null);
        //                });
        //                markers = [];
        //                // For each place, get the icon, name and location.
        //                const bounds = new google.maps.LatLngBounds();
        //                places.forEach(place => {
        //                    if (!place.geometry) {
        //                        console.log("Returned place contains no geometry");
        //                        return;
        //                    }
        //                    const icon = {
        //                        url: place.icon,
        //                        size: new google.maps.Size(71, 71),
        //                        origin: new google.maps.Point(0, 0),
        //                        anchor: new google.maps.Point(17, 34),
        //                        scaledSize: new google.maps.Size(25, 25)
        //                    };
        //                    // Create a marker for each place.
        //                    markers.push(
        //                      new google.maps.Marker({
        //                          map,
        //                          icon,
        //                          title: place.name,
        //                          position: place.geometry.location
        //                      })
        //                    );

        //                    if (place.geometry.viewport) {
        //                        // Only geocodes have viewport.
        //                        bounds.union(place.geometry.viewport);
        //                    } else {
        //                        bounds.extend(place.geometry.location);
        //                    }
        //                });
        //                map.fitBounds(bounds);
        //            });
            

    </script>

        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&callback=initMap&language=en&libraries=places"></script>
</body>
</html>
