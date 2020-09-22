<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MapGeocoding.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html>
<head>
    <style>
        /* Set the size of the div element that contains the map */
        #map {
            height: 400px; /* The height is 400 pixels */
            width: 100%; /* The width is the width of the web page */
        }
    </style>

    </script>
      
</head>
<body>
    <h3>My Google Maps Demo</h3>
    <!--The div element for the map -->
    <div id="map"></div>
    <script type="text/javascript">

        var geocoder = new google.maps.Geocoder();
        var infowindow = new google.maps.InfoWindow();
        var latlang = new google.maps.LatLng(25.14, 55.18);
        function initMap() {
            var myOptions = {
                center: latlang,
                zoom: 5,
                mapTypeId: google.maps.MapTypeId.ROADMAP

            };
            var map = new google.maps.Map(document.getElementById("map"), myOptions);
            geocoder.geocode({ 'latLng': latlang }, function (items, status) {

                if (status == google.maps.GeocoderStatus.OK) {

                    map.setZoom(8);

                    var marker = new google.maps.Marker({
                        position: latlang,
                        map: map
                    });

                    infowindow.setContent(items[1].formatted_address);
                    google.maps.event.addListener(marker, 'click', function () {


                        infowindow.open(map, this);
                        map.setZoom(8);
                    });
                }

            });
            google.maps.event.addListener(map, 'click', function (event) {

                geocoder.geocode({ 'latLng': event.latLng }, function (items, status) {

                    if (status == google.maps.GeocoderStatus.OK) {
                        $('#latitude').val(items[0].geometry.location.lat().toString().substr(0, 12));
                        $('#longitude').val(items[0].geometry.location.lng().toString().substr(0, 12));
                        map.setZoom(8);
                        marker = new google.maps.Marker({
                            position: event.latLng,
                            map: map
                        });

                        var ll = event.latLng;
                        infowindow.setContent(ll.toString());
                        infowindow.open(map, marker);

                    }

                });
            });
        }

    </script>
    <!--Load the API from the specified URL
    * The async attribute allows the browser to render the page while the API loads
    * The key parameter will contain your own API key (which is not needed for this tutorial)
    * The callback parameter executes the initMap() function
    -->

    <input type="button" onclick="GetMapPosition()" value="Get Lat Long" />
</body>
</html>
