<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GMapsOriginal.aspx.cs" Inherits="GMapsOriginal" %>

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
    <script src="Resources/js/common.js"></script>
    <script src="Resources/js/GMapsOriginal.js"></script>
    <script>
        $(document).ready(function () {
            BindAreas();

            $('#cmbArea').change(function () {
                
                var selectedValue = $("#cmbArea option:selected").val();
                var selectedArea = getAreaByAreaId(parseInt(selectedValue));
                $(".inpAreaLatitude").val(selectedArea.Latitude);
                $(".inpAreaLongitude").val(selectedArea.Longitude);
                $(".inpCircleRadius").val(selectedArea.Radius);
            });
        });

    </script>
</head>
<body>
    <form id="form1" runat="server">

        <div id="InputFields">
            <h3>Address Fields:</h3>
            Select Area:
            <select id="cmbArea" style="width: 300px">             
            </select>
            <input type="text" placeholder="Building Address" class="inpBuilding"  id="wtinpBuildingAddress" />
            <br />
            <input type="text" placeholder="Street Address" class="inpStreet"  id="inpStreet" />
            <input type="text" placeholder="Landmark Address" id="wtinpLandmarkAddress" />
            <br />
            Default Lat:<input type="text" placeholder="Default Latitude" class="inpAreaLatitude" id="inpDefaultLat" />
            <br />
            Default Long:<input type="text" placeholder="Default Longitude" class="inpAreaLongitude" id="inpDefaultLong" />
            <br />
            Radius:
            <input type="text" placeholder="Circle Radius" class="inpCircleRadius" id="wtinpCircleRadius" />
        </div>


        <div class="MapPlaceHolder" style="margin-top: 20px; margin-bottom: 20px">
            <span>Map will be loaded here!</span>
        </div>

        <div style="margin-top: 20px">
            <h3>Get Coordinates Section:</h3>
            <input type="button" value="Load Map" onclick="LoadMap()" />
        </div>
    </form>
</body>
</html>
