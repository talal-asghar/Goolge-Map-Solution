<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AutocompleteWithMap.aspx.cs" Inherits="AutocompleteWithMap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        #map {
            height: 100%;
            width:100%;
            position:inherit !important;
            overflow:initial !important;
        }

        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #my-input-searchbox {
            box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.16), 0 0 0 1px rgba(0, 0, 0, 0.08);
            font-size: 15px;
            border-radius: 3px;
            border: 0;
            margin-top: 10px;
            width: 270px;
            height: 40px;
            text-overflow: ellipsis;
            padding: 0 1em;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input id="my-input-searchbox" type="text" placeholder="Autocomplete Search" />
            <div id="map"></div>
            <!-- Replace the value of the key parameter with your own API key. -->

        </div>
    </form>
    <script>
        function initAutocomplete() {

            var element = document.getElementById('map');
            var latlang = new google.maps.LatLng(25.14, 55.18);
            var map = new google.maps.Map(document.getElementById('map'), {
                center: latlang,
                zoom: 10,
                componentRestrictions: {
                    country: 'AE'
                }
            });

            // Create the search box and link it to the UI element.
            var input = document.getElementById('my-input-searchbox');
            var options = {
                componentRestrictions: {
                    country: 'AE'
                }
            };
            var autocomplete = new google.maps.places.Autocomplete(input, options);
            map.controls[google.maps.ControlPosition.TOP_CENTER].push(input);
            var marker = new google.maps.Marker({
                map: map
            });

            // Bias the SearchBox results towards current map's viewport.
            autocomplete.bindTo('bounds', map);
            // Set the data fields to return when the user selects a place.
            autocomplete.setFields(
              ['address_components', 'geometry', 'name']);

            // Listen for the event fired when the user selects a prediction and retrieve
            // more details for that place.
            autocomplete.addListener('place_changed', function () {
                var place = autocomplete.getPlace();
                if (!place.geometry) {
                    console.log("Returned place contains no geometry");
                    return;
                }
                var bounds = new google.maps.LatLngBounds();
                marker.setPosition(place.geometry.location);

                if (place.geometry.viewport) {
                    // Only geocodes have viewport.
                    bounds.union(place.geometry.viewport);
                } else {
                    bounds.extend(place.geometry.location);
                }
                map.fitBounds(bounds);
                map.setZoom(14);
            });
        }
        document.addEventListener("DOMContentLoaded", function (event) {
            initAutocomplete();
        });
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&libraries=places"></script>
</body>
</html>
