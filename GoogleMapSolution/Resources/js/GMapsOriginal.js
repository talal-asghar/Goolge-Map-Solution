﻿/**
 * Class that encapsulates all created Google Maps objects and abstracts
 * some of the events triggered
 */

function MapNotifyResponse(isError, errorCode, coordinates, address) {
    this.IsError = isError;
    this.ErrorCode = errorCode;
    this.MapCoordinates = coordinates;
    this.ReverseGeoCodedAddress = address;
}

function MapCoordinates(latitude, longitude) {
    this.Latitude = latitude;
    this.Longitude = longitude;
}

const ErrorCodes = {
    OutsideCircle: 'OUTSIDE_CIRCLE',
    BuildingFoundOutsideCircle: 'BUILDING_OUTSIDE_CIRCLE',
    AddressNotFound: 'ADDRESS_NOT_FOUND'
}

var MapOptions = new function () {

    this.getBuildingWithAreaEmirate = function () {
        var fullAddress = '';

        var building = $("input[class*='inpBuilding']");
        if (building.length > 0)
            fullAddress = building.val();

        var area = $("input[class*='inpOtherArea']");
        if (area.length > 0)
            fullAddress = fullAddress + " " + area.val();

        var emirate = $(".cmbEmirate option:selected");
        if (emirate.length > 0 && !emirate.val().includes('0'))
            fullAddress = fullAddress + " " + emirate.text();

        return fullAddress;
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
            return $("input[class*='inpAreaLatitude']")[0].value;
        } catch (err) {
            console.log('cannot get latitude');
            return "";
        }
    };
    this.getLongitude = function () {

        try {
            return $("input[class*='inpAreaLongitude']")[0].value;
        } catch (err) {
            console.log('cannot get latitude');
            return "";
        }
    };
    this.getZoom = function () {

        try {
            return parseInt($("input[id*='wtinpZoomLevel']")[0].value);
        } catch (err) {
            return 13;
            return "";
        }
    };
    this.getCircleRadius = function () {

        try {
            return parseInt($("input[class*='inpCircleRadius']")[0].value);
        } catch (err) {
            return 3000;
        }
    };
    this.setCoordinates = function (coordinates) {

        document.getElementsByClassName('Coordinates')[0].value = coordinates;
    };
    this.getCoordinates = function () {
        return document.getElementsByClassName('Coordinates')[0].value;
    };
    this.getBuilding = function () {
        var building = $("input[class*='inpBuilding']");
        if (building.length > 0)
            return building.val();
        else
            return "";
    };
    this.getStreet = function () {
        var street = $("input[class*='inpStreet']");
        if (street.length > 0)
            return street.val();
        else
            return "";
    };
    this.getAreaValue = function () {
        var area = $(".cmbDeliveryArea option:selected");
        if (area.length > 0)
            return area.val();
        else
            return "";
    };
    this.getAreaText = function () {
        var area = $(".cmbDeliveryArea option:selected");
        if (area.length > 0)
            return area.text();
        else
            return "";
    };
    this.getEmirateText = function () {
        var emirate = $(".cmbEmirate option:selected");
        if (emirate.length > 0 && !emirate.val().includes('0'))
            return emirate.text();
        else
            return "";
    };
    this.IsUnknownArea = function () {
        var chkBoxIsUnknown = $(".chkBoxIsUnknown");

        if (chkBoxIsUnknown.length > 0)
            return chkBoxIsUnknown.is(':checked');
        else
            return false;
    }

    this.IsPredictionSearchEnabled = function () {
        var chkBoxPredictionSearch = $(".chkBoxPredictionSearchEnabled");

        if (chkBoxPredictionSearch.length > 0)
            return chkBoxPredictionSearch.is(':checked');
        else
            return false;
    }
}




/*Google API Class and functions*/

var GoogleMapAPI = new function () {

    this.map;
    this.geoCoder;
    this.placeService;
    this.markers = [];
    this.circles = [];
    this.defaultCoordinates;
    this.areaCoordinates
    this.getDefaultCoorindates = function () {
        if (this.defaultCoordinates == undefined || this.defaultCoordinates == null) {
            this.defaultCoordinates = new google.maps.LatLng(MapOptions.getLatitude(), MapOptions.getLongitude());
        }
        return this.defaultCoordinates;
    };
    this.getUAEBounds = function () {
        var bounds = {
            south: 22.4969475367,
            west: 51.5795186705,
            north: 26.055464179,
            east: 56.3968473651
        };
        return bounds;
    };
    this.getAreaCoorindates = function () {
        this.areaCoordinates = new google.maps.LatLng(MapOptions.getLatitude(), MapOptions.getLongitude());
        return this.areaCoordinates;
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
    this.setMapNewCenterWithoutBounds = setMapNewCenterWithoutBounds;
    this.addMarker = addMarker;
    this.clearMarkers = clearMarkers;
    this.deleteMarkers = deleteMarkers;
    this.setMapOnAllMarkers = setMapOnAllMarkers
    this.createCircle = createCircle;
    this.deleteCircles = deleteCircles;
    this.geoCodeAddress = geoCodeAddress;
    this.geoCodeAddressWithBounds = geoCodeAddressWithBounds;
    this.getPlacesFromQuery = getPlacesFromQuery;
    this.reverseGeoCodeAddress = reverseGeoCodeAddress;
}

function initializeMap() {

    ShowMap();
    var mapPlaceHolder = document.getElementsByClassName('MapPlaceHolder')[0];
    if (this.map == undefined || this.map == null || mapPlaceHolder.innerHTML == '') {
        this.map = new google.maps.Map(mapPlaceHolder);
    }
};

function addMarker(location) {
    const marker = new google.maps.Marker({
        position: location,
        map: this.map
    });
    this.markers.push(marker);

}

function geoCodeAddress(address, callback) {

    this.getGeoCoder().geocode({
        'address': address,
        componentRestrictions: {
            country: 'AE'
        }
    }, callback);
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
        radius: MapOptions.getCircleRadius(), // IN METERS.
        fillColor: '#FF6600',
        fillOpacity: 0.3,
        strokeColor: "#FFF",
        clickable: true,
        strokeWeight: 0 // DON'T SHOW CIRCLE BORDER.
    });

    google.maps.event.addListener(circle, 'click', CircleClicked);

    this.circles.push(circle);
}

function deleteCircles() {

    for (let i = 0; i < this.circles.length; i++) {
        google.maps.event.clearListeners(this.circles[i], 'click');
        this.circles[i].setMap(null);
    }
    this.circles = [];
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

function geoCodeAddressWithBounds(address, bounds, callBack) {

    if (address == '')
        console.log('Invalid address');
    else {
        this.getGeoCoder().geocode({
            'address': address,

            componentRestrictions: {
                country: 'AE'
            }
        }, callBack);
    }
};

function setMapNewCenter(coordinates) {

    var options = {
        center: coordinates,
        zoom: MapOptions.getZoom(),
        streetViewControl: false,
        mapTypeControl: false,
        fullscreenControl: false
    };

    this.deleteMarkers();
    this.map.setOptions(options);
    this.addMarker(coordinates);
}

function setMapNewCenterWithoutBounds(coordinates) {

    var options = {
        center: coordinates,
        zoom: MapOptions.getZoom(),
        streetViewControl: false,
        mapTypeControl: false,
        fullscreenControl: false
    };

    this.deleteMarkers();
    //  this.deleteCircles();
    this.setMapBounds(this.getUAEBounds());
    this.map.setOptions(options);
    //    this.addMarker(coordinates);

}

function reverseGeoCodeAddress(latlng) {

    this.getGeoCoder().geocode({ location: latlng }, function (results, status) {

        if (status == google.maps.GeocoderStatus.OK) {
            if (results[0]) {
                NotifyCoordinatesToParent(latlng, results[0].formatted_address);
            } else {
                window.alert("No results found");
            }
        } else {
            window.alert("Geocoder failed due to: " + status);
        }
    });
}

function LoadMap() {

    GoogleMapAPI.initializeMap();
    var coordinates = GoogleMapAPI.getAreaCoorindates();

    if (coordinates.lat() == 0 || coordinates.lng() == 0) //Search for Other Area
        GoogleMapAPI.geoCodeAddress(MapOptions.getBuildingWithAreaEmirate(), GeoCodeResponse_SetCoordinatesMapCenter);
    else {
        //        GoogleMapAPI.setMapNewCenter(coordinates);
        GoogleMapAPI.geoCodeAddress(MapOptions.getBuilding() + " " + MapOptions.getAreaText() + " " + MapOptions.getEmirateText(), GeoCodeResponse_SetCoordinatesMapCenter);
    }

    google.maps.event.clearListeners(GoogleMapAPI.map, 'click');
    google.maps.event.addListener(GoogleMapAPI.map, 'click', MapClickCallback);

}

function LoadMapWithCoordinates(lat, lng) {

    GoogleMapAPI.initializeMap();

    var coordinates = new google.maps.LatLng(lat, lng);
    var areaCoordinates = GoogleMapAPI.getAreaCoorindates();

    console.log('Finding location by coordinates');
    if (areaCoordinates.lat() == 0 || areaCoordinates.lng() == 0) //Search for Other Area
    {

        GoogleMapAPI.setMapNewCenterWithoutBounds(coordinates);
    }
    else {
        GoogleMapAPI.setMapNewCenterWithoutBounds(coordinates);
    }

    GoogleMapAPI.addMarker(coordinates);

    google.maps.event.clearListeners(GoogleMapAPI.map, 'click');
    google.maps.event.addListener(GoogleMapAPI.map, 'click', MapClickCallback);
}


function MapClickCallback(event) {

    //var areaValue = MapOptions.getAreaValue();
    //if (MapOptions.IsUnknownArea()) {
    GoogleMapAPI.deleteMarkers();
    GoogleMapAPI.addMarker(event.latLng);
    GoogleMapAPI.reverseGeoCodeAddress(event.latLng);
    //} else {
    //    var notifyResponse = new MapNotifyResponse(true, ErrorCodes.OutsideCircle, null);
    //    fakeNotify(notifyResponse);
    //}
}

function GeoCodeResponse_SetCoordinatesMapCenter(results, status) {


    if (status == google.maps.GeocoderStatus.OK) {

        //Set on first result center
        GoogleMapAPI.setMapNewCenterWithoutBounds(results[0].geometry.location);

        //Set All Markers
        for (var i = 0; i < results.length; i++) {
            GoogleMapAPI.addMarker(results[i].geometry.location);
        }

    } else {
        var notifyResponse = new MapNotifyResponse(true, ErrorCodes.AddressNotFound, null);
        fakeNotify(notifyResponse);
    }
}

function GeoCodeResponse_VerifyBounds(results, status) {

    if (status == google.maps.GeocoderStatus.OK) {

        //Get bounds of circle
        var center = GoogleMapAPI.circles[0].getCenter();
        var radius = GoogleMapAPI.circles[0].getRadius();
        let deleteDefaultAreaMarker = true;
        let isResultFoundInsideBounds = false;

        for (var i = 0; i < results.length; i++) {

            var isInsideBoundary = IsLocationInsideCircle(results[i].geometry.location, center, radius / 1000);

            if (isInsideBoundary) { //check if found coordiantes are inside circle

                if (deleteDefaultAreaMarker === true) { //Only delete once if multiple results are found
                    GoogleMapAPI.deleteMarkers();
                    deleteDefaultAreaMarker = false;
                }
                GoogleMapAPI.addMarker(results[i].geometry.location);
                isResultFoundInsideBounds = true;
            }
        }
        if (isResultFoundInsideBounds === false) {
            if (MapOptions.IsPredictionSearchEnabled() == true)
                GoogleMapAPI.getPlacesFromQuery(MapOptions.getBuilding(), CallbackPlaceServiceQuerySearchWithBuilding);
            else {
                var notifyResponse = new MapNotifyResponse(true, ErrorCodes.BuildingFoundOutsideCircle, null);
                fakeNotify(notifyResponse);
            }
        }
    }
    else {
        if (MapOptions.IsPredictionSearchEnabled() == true)
            GoogleMapAPI.getPlacesFromQuery(MapOptions.getBuilding(), CallbackPlaceServiceQuerySearchWithBuilding);
        else {
            var notifyResponse = new MapNotifyResponse(true, ErrorCodes.AddressNotFound, null);
            fakeNotify(notifyResponse);
        }
    }
}

function fakeNotify(message) {
    var element = $("span[id*='mapFakeNotify']")
    if (element.length > 0) {
        OsNotifyWidget(element.attr('id'), JSON.stringify(message));
    }
    return false;
}

function ShowMap() {
    $('.MapPlaceHolder').removeClass('Hidden');
    $('.MapDummyContainer').addClass('Hidden');
}

function HideMap() {
    $('.MapPlaceHolder').addClass('Hidden');
    $('.MapDummyContainer').removeClass('Hidden');
}

function CircleClicked(event) {


    GoogleMapAPI.deleteMarkers();
    GoogleMapAPI.addMarker(event.latLng);
    GoogleMapAPI.reverseGeoCodeAddress(event.latLng);
}


function NotifyCoordinatesToParent(location, address) {

    var element = $("span[id*='mapFakeNotify']")
    var coordinates = new MapCoordinates(location.lat(), location.lng());
    var notifyResponse = new MapNotifyResponse(false, '', coordinates, address);
    if (element.length > 0) {
        OsNotifyWidget(element.attr('id'), JSON.stringify(notifyResponse));
    }
    return false;
}

function getPlacesFromQuery(address, callback) {

    if (address == "") {
        console.log('Address not entered for predictions');
    }
    else {
        console.log('Searching place from query ' + address);

        if (this.placeService == null || this.placeService == undefined) {
            var dummyContainer = $('.PlaceSearchContainer');
            placeService = new google.maps.places.PlacesService(dummyContainer.get(0));
        }

        var request = {
            locationBias: { radius: MapOptions.getCircleRadius(), center: this.getAreaCoorindates() },
            query: address,
            fields: ['formatted_address', 'geometry']
        };

        placeService.findPlaceFromQuery(request, callback);
    }
}

function CallbackPlaceServiceQuerySearchWithBuilding(results, status) {

    if (status == google.maps.places.PlacesServiceStatus.OK) {

        console.log('Results found from place API');

        let isResultFoundInsideBounds = ValidatePlaceQueryResult(results);

        if (isResultFoundInsideBounds === false) {
            GoogleMapAPI.getPlacesFromQuery(MapOptions.getBuilding() + " " + MapOptions.getAreaText(), CallbackPlaceServiceQuerySearchWithBuildingArea);
        }
    }
    else {
        GoogleMapAPI.getPlacesFromQuery(MapOptions.getBuilding() + " " + MapOptions.getAreaText(), CallbackPlaceServiceQuerySearchWithBuildingArea);
    }
}

function CallbackPlaceServiceQuerySearchWithBuildingArea(results, status) {

    if (status == google.maps.places.PlacesServiceStatus.OK) {

        console.log('Results found from place API with area');

        let isResultFoundInsideBounds = ValidatePlaceQueryResult(results);

        if (isResultFoundInsideBounds === false) {
            var notifyResponse = new MapNotifyResponse(true, ErrorCodes.BuildingFoundOutsideCircle, null);
            fakeNotify(notifyResponse);
        }
    }
    else {
        var notifyResponse = new MapNotifyResponse(true, ErrorCodes.AddressNotFound, null);
        fakeNotify(notifyResponse);
    }
}

function ValidatePlaceQueryResult(results) {

    var center = GoogleMapAPI.circles[0].getCenter();
    var radius = GoogleMapAPI.circles[0].getRadius();
    let deleteDefaultAreaMarker = true;
    let isResultFoundInsideBounds = false;

    for (var i = 0; i < results.length; i++) {

        var isInsideBoundary = IsLocationInsideCircle(results[i].geometry.location, center, radius / 1000);

        if (isInsideBoundary) { //check if found coordiantes are inside circle

            if (deleteDefaultAreaMarker === true) { //Only delete once if multiple results are found
                GoogleMapAPI.deleteMarkers();
                deleteDefaultAreaMarker = false;
            }
            GoogleMapAPI.addMarker(results[i].geometry.location);
            isResultFoundInsideBounds = true;
        }
    }
    return isResultFoundInsideBounds;
}

function IsLocationInsideCircle(checkPoint, centerPoint, km) {
    var ky = 40000 / 360;
    var kx = Math.cos(Math.PI * centerPoint.lat() / 180.0) * ky;
    var dx = Math.abs(centerPoint.lng() - checkPoint.lng()) * kx;
    var dy = Math.abs(centerPoint.lat() - checkPoint.lat()) * ky;
    return Math.sqrt(dx * dx + dy * dy) <= km;
}