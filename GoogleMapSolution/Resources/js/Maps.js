/**
 * Class that encapsulates all created Google Maps objects and abstracts
 * some of the events triggered
 */

var MapOptions = new function () {

    this.getBuildingAddress = function () {
        try {
            return $("input[id*='wtinpBuildingAddress']")[0].value;
        } catch (err) {
            console.log('Address not found');
            return "";
        }
    };
    this.getLandmarkAddress = function () {
        try {
            return $("input[id*='wtinpLandmarkAddress']")[0].value;
        } catch (err) {
            console.log('Landmark not found');
            return "";
        }
    };
    this.getLatitude = function () {

        try {
            return $("input[id*='inpDefaultLat']")[0].value;
        } catch (err) {
            console.log('cannot get latitude');
            return "";
        }
    };
    this.getLongitude = function () {

        try {
            return $("input[id*='inpDefaultLong']")[0].value;
        } catch (err) {
            console.log('cannot get latitude');
            return "";
        }
    };
    this.getZoom = function () {

        try {
            return $("input[id*='wtinptZoom']")[0].value;
        } catch (err) {
            return 13;
            return "";
        }
    };
    this.getCircleRadius = function () {

        try {
            return parseInt($("input[id*='wtinpCircleRadius']")[0].value);
        } catch (err) {
            return 3000;
            return "";
        }
    };
    this.setCoordinates = function (coordinates) {
        debugger
        document.getElementsByClassName('Coordinates')[0].value = coordinates;
    };
    this.getCoordinates = function () {
        return document.getElementsByClassName('Coordinates')[0].value;
    }
}


var mapInstance;

function initMap() {

    //mapInstance=new GoogleMapAPI();
    GoogleMapAPI.initializeMap();
    GoogleMapAPI.deleteMarkers();
    GoogleMapAPI.addMarker(GoogleMapAPI.getDefaultCoorindates());


    google.maps.event.clearListeners(GoogleMapAPI.map, 'click');
    google.maps.event.addListener(GoogleMapAPI.map, 'click', MapClickedCallback);

    if (MapOptions.getBuildingAddress() != '')
        GoogleMapAPI.geoCodeAddress(MapOptions.getBuildingAddress());

}

function MapClickedCallback(event) {
    debugger
    alert('Please choose a location inside circle');
    //   GoogleMapAPI.map.setCenter(event.latLng);
    //    GoogleMapAPI.deleteMarkers();
    //    GoogleMapAPI.addMarker(event.latLng);
    //    MapOptions.setCoordinates(event.latLng);
}

var GoogleMapAPI = new function () {

    this.map;
    this.geoCoder;
    this.markers = [];
    this.circles = [];
    this.defaultCoordinates;
    this.getDefaultCoorindates = function () {
        if (this.defaultCoordinates == undefined || this.defaultCoordinates == null) {
            this.defaultCoordinates = new google.maps.LatLng(MapOptions.getLatitude(), MapOptions.getLongitude());
        }
        return this.defaultCoordinates;
    };
    this.getGeoCoder = function () {

        if (this.geoCoder == undefined || this.geoCoder == null) {
            this.geoCoder = new google.maps.Geocoder();
        }
        return this.geoCoder;
    };

    this.initializeMap = initializeMap;
    this.setMapBounds = setMapBounds
    this.setMapNewCenter = setMapNewCenter;
    this.addMarker = addMarker;
    this.clearMarkers = clearMarkers;
    this.deleteMarkers = deleteMarkers;
    this.setMapOnAllMarkers = setMapOnAllMarkers
    this.createCircle = createCircle;
    this.deleteCircles = deleteCircles;
    this.geoCodeAddress = geoCodeAddress;
    this.geoCodeAddressWithBounds = geoCodeAddressWithBounds;
}

function initializeMap() {

    if (this.map == undefined || this.map == null) {
        var options = {
            center: this.getDefaultCoorindates(),
            zoom: MapOptions.getZoom(),
            streetViewControl: false,
            mapTypeControl: false,
            fullscreenControl: false
        };

        this.map = new google.maps.Map(
            document.getElementsByClassName('MapPlaceHolder')[0], options);
    }
};

function addMarker(location) {
    const marker = new google.maps.Marker({
        position: location,
        map: this.map
    });
    this.markers.push(marker);

}



function geoCodeAddress(address, bounds) {
    debugger
    this.getGeoCoder().geocode({
        'address': address,
        bounds: bounds,
        componentRestrictions: {
            country: 'AE'
        }
    }, function (results, status) {
        if (status === 'OK') {
            debugger
            GoogleMapAPI.deleteMarkers();
            GoogleMapAPI.map.setCenter(results[0].geometry.location);

            GoogleMapAPI.addMarker(results[0].geometry.location);
            MapOptions.setCoordinates(Jresults[0].geometry.location);

        } else {
            alert('Geocode location not found.');
            //            alert('Geocode was not successful for the following reason: ' + status);
        }
    });

};


function setMapOnAllMarkers(map) {
    for (let i = 0; i < this.markers.length; i++) {
        this.markers[i].setMap(map);
    }
}

function deleteMarkers() {
    this.clearMarkers();
    this.markers = [];
}

function clearMarkers() {
    this.setMapOnAllMarkers(null);
}

function createCircle(location) {

    if (location == undefined)
        location = this.getDefaultCoorindates();

    const circle = new google.maps.Circle({
        center: location,
        map: this.map,
        radius: MapOptions.getCircleRadius(),          // IN METERS.
        fillColor: '#FF6600',
        fillOpacity: 0.3,
        strokeColor: "#FFF",
        clickable: true,
        strokeWeight: 0         // DON'T SHOW CIRCLE BORDER.
    });

    google.maps.event.addListener(circle, 'click', CircleClicked);


    this.circles.push(circle);
}

function deleteCircles() {
    debugger
    for (let i = 0; i < this.circles.length; i++) {
        google.maps.event.clearListeners(this.circles[i], 'click');
        this.circles[i].setMap(null);
    }
    this.circles = [];
}

function CircleClicked(event) {

    GoogleMapAPI.deleteMarkers();
    GoogleMapAPI.addMarker(event.latLng);
    MapOptions.setCoordinates(event.latLng);
}

function setMapBounds(bounds) {
    var options = {
        restriction: {
            latLngBounds: bounds,
            strictBounds: false
        }
    }
    this.map.setOptions(options);
}


function geoCodeAddressWithBounds(address, bounds) {
    debugger
    this.getGeoCoder().geocode({
        'address': address,
        bounds: bounds,
        componentRestrictions: {
            country: 'AE'
        }
    }, function (results, status) {
        if (status === 'OK') {

            MapOptions.setCoordinates(JSON.stringify(results[0].geometry.location));
            var result = bounds.contains(results[0].geometry.location);
//            alert(result);

            //    var point;

            //    // Find first location inside restricted area
            //    for (var i = 0 ; i < results.length ; i++) {
            //        point = results[i].geometry.location;
            //        // I compare my lng values this way because their are negative
            //        if (point.lat() > latMin && point.lat() < latMax && point.lng() < lngMin && point.lng() > lngMax) {
            //            alert('Result inside circle');
            //        }
            //        // No results inside our area
            //        if (i == (results.length - 1)) {
            //            alert("Result outside circle");
            //        }
            //    }


            //} else {
            //    alert('Geocode location not found.');
            //    //            alert('Geocode was not successful for the following reason: ' + status);
            //}
        }
    });

};

function setMapNewCenter() {

    debugger
    var coordinates = JSON.parse(MapOptions.getCoordinates());
    var options = {
        center: coordinates,
        zoom: MapOptions.getZoom(),
        streetViewControl: false,
        mapTypeControl: false,
        fullscreenControl: false
    };

    this.deleteMarkers();
    this.deleteCircles();
    this.map.setOptions(options);
    this.addMarker(coordinates);
    this.createCircle(coordinates);
    this.setMapBounds(this.circles[0].getBounds());
}

function GeoCodeWithBounds() {

    GoogleMapAPI.geoCodeAddressWithBounds(MapOptions.getBuildingAddress(), GoogleMapAPI.circles[0].getBounds());
}