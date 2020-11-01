﻿var baseURL = 'http://catalog.api.2gis.ru/3.0/items?'
var key = 'ruydfq9322';
var mapGIS;
var marker;

function GeoCodeAddress2GIS(address, lat, lng, radius) {
    var geoCodeURL = baseURL + "key=" + key + "&q=" + address + "&fields=items.geometry.centroid&type=building&region_id=99&point=" + lng + "," + lat + "&radius=" + radius;
    console.log(geoCodeURL);
    var jqxhr = $.get(geoCodeURL, function (response) {
        debugger
        if (response.result === undefined || response.result.items.length == 0) {
            alert('Result not found');
            return;
        }

        var center = response.result.items[0].geometry.centroid
        var replacedString = response.result.items[0].geometry.centroid.replace("POINT(", "").replace(")", "");
        var splitString = replacedString.split(' ');
        LoadGISMap(parseFloat(splitString[1]), parseFloat(splitString[0]));

    }).fail(function (response) {
        alert('failure');
    })

}


function GetPredictionBasedResult(address, lat, lng, radius) {
    var geoCodeURL = baseURL + "key=" + key + "&q=" + address + "&fields=items.geometry.centroid&type=building&region_id=99&point=" + lng + "," + lat + "&radius=" + radius;
    console.log(geoCodeURL);
    var jqxhr = $.get(geoCodeURL, function (response) {
        debugger
        if (response.result === undefined || response.result.items.length == 0) {
            alert('Result not found');
            return;
        }

        var center = response.result.items[0].geometry.centroid
        var replacedString = response.result.items[0].geometry.centroid.replace("POINT(", "").replace(")", "");
        var splitString = replacedString.split(' ');
        LoadGISMap(parseFloat(splitString[1]), parseFloat(splitString[0]));

    }).fail(function (response) {
        alert('failure');
    })

}

function LoadGISMap(lat, lng) {
    debugger
    //   markers = DG.featureGroup();

    if (mapGIS == null || mapGIS == undefined) {
        DG.then(function () {
            mapGIS = DG.map('2GISMap', {
                center: [lat, lng],
                zoom: 15
            });
            mapGIS.on('click', GISMapClickCallback);
            AddMarkerGIS(lat, lng);
        });
    }
    else {

        mapGIS.setView([lat, lng], 15);
        AddMarkerGIS(lat, lng);
    }


}
function AddMarkerGIS(lat, lng) {

    if (marker != undefined)
        RemoveMarkerGIS();
    marker = DG.marker([lat, lng]);
    marker.addTo(mapGIS);

    //   DG.marker([lat, lng]).addTo(markers);
    //    markers.addTo(map);
    // DG.marker([lat, lng]).addTo(map);
}

function RemoveMarkerGIS() {

    marker.removeFrom(mapGIS);

    // DG.marker([lat, lng]).addTo(map);
}



function GISMapClickCallback(event) {
    AddMarkerGIS(event.latlng.lat, event.latlng.lng);
    ReverseGeoCodeCoordinates2GIS(event.latlng.lat, event.latlng.lng);
}

function ReverseGeoCodeCoordinates2GIS(lat, lng) {
    debugger
    $("#txt2GISRevereseGeocoded").val("");
    $("#txt2GISBuilding").val("");
    $("#txt2GISStreet").val("");

    var reverseGeoCodeURL = baseURL + "key=" + key + "&q=" + lat + "," + lng + "&fields=items.address&region_id=99";
    console.log(reverseGeoCodeURL);
    var jqxhr = $.get(reverseGeoCodeURL, function (response) {
        if (response.result === undefined || response.result.items.length == 0) {
            alert('Address not found');
            return;
        }
        console.log(JSON.stringify(response.result));
        $("#txt2GISRevereseGeocoded").val(response.result.items[0].address_name);
        $("#txt2GISBuilding").val(response.result.items[0].building_name);
        if (response.result.items[0].address != undefined)
            if (response.result.items[0].address.components.length > 0)
                $("#txt2GISStreet").val(response.result.items[0].address.components[0].street);

        //var center = response.result.items[0].geometry.centroid
        //var replacedString = response.result.items[0].geometry.centroid.replace("POINT(", "").replace(")", "");
        //var splitString = replacedString.split(' ');
        //LoadMap(parseFloat(splitString[1]), parseFloat(splitString[0]));

    }).fail(function (response) {
        alert('failure');
    })

}