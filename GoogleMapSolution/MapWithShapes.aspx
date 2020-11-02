<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MapWithShapes.aspx.cs" Inherits="MapWithShapes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
    <link href="Resources/style/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="padding: 20px">
            <div id="InputFields">
                <h3>Address Fields:</h3>
                <input type="text" placeholder="Building Address" class="inpBuilding" value="Building 80 Discovery Gardens" id="wtinpBuildingAddress" />
                <input type="text" placeholder="Landmark Address" id="wtinpLandmarkAddress" />
                <br />
                <input type="text" placeholder="Default Latitude" class="inpAreaLatitude" value="25.0390117" id="inpDefaultLat" />
                <input type="text" placeholder="Default Longitude" value="55.1444815" class="inpAreaLongitude" id="inpDefaultLong" />
                <br />
                <input type="text" placeholder="Circle Radius" class="inpCircleRadius" id="wtinpCircleRadius" value="1000" />
                <input type="checkbox" class="chkBoxPredictionSearchEnabled" checked="checked" />
            </div>


            <div class="MapPlaceHolder" style="margin-top: 20px; margin-bottom: 20px">
                <span>Map will be loaded here!</span>
            </div>

            <div style="margin-top: 20px">
                <h3>Get Coordinates Section:</h3>
                <input type="button" value="Load Map" onclick="LoadMap()" />
                <input type="text" placeholder="Coorindates" id="inputCoordinates" class="Coordinates" />
                <input type="button" onclick="GoogleMapAPI.createCircle()" value="Create Circle" />
                <input type="button" onclick="GoogleMapAPI.deleteCircles()" value="Delete All Circles" />
                <input type="button" onclick="GoogleMapAPI.createPolygon()" value="Create Polygon" />
                <input type="button" onclick="GoogleMapAPI.deletePolygon()" value="Delete All Polygons" />
                <input type="button" onclick="GeoCodeWithBounds()" value="Geocode with Bounds" />
                <input type="button" onclick="GoogleMapAPI.setMapNewCenter()" value="Set Map New Geocoded Center" />
            </div>
        </div>
        <div class="PlaceSearchContainer"></div>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&language=en&libraries=places"></script>
        <script src="Resources/js/GMaps.js"></script>
    </form>
</body>
</html>
