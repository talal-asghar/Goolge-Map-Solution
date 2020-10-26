<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GMapVs2GIS.aspx.cs" Inherits="GMapVs2GIS" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&language=en&libraries=places"></script>
    <script src="https://maps.api.2gis.ru/2.0/loader.js?pkg=full"></script>

    <script src="Resources/js/common.js"></script>
    <script src="Resources/js/GMaps.js"></script>
    <script src="Resources/js/2GIS.js"></script>
    <script>

        $(document).ready(function () {
            BindAreas();

            $('#cmbArea').change(function () {
                var selectedValue = $("#cmbArea option:selected").val();
                var selectedArea = getAreaByAreaId(parseInt(selectedValue));
                $("#latitude").val(selectedArea.Latitude);
                $("#longitude").val(selectedArea.Longitude);
                $("#radius").val(selectedArea.Radius);
            });
        });

        function Load2GISMap() {
            debugger
            var building = $("#txtBuildingSearch").val();
            var area = $("#cmbArea option:selected").text();
            GeoCodeAddress2GIS(building + " - " + area);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Enter Building and Street:
            <input type="text" id="txtBuildingSearch" />
            <br />
            Select Area:
              <select id="cmbArea" style="width: 300px">
                  <option value="0">Select Area</option>
              </select>
            <br />
            <input type="text" id="latitude" value="25.2201105" placeholder="Latitude" />
            <input type="text" id="longitude" value="55.2563077" placeholder="Longitude" />
            <input type="text" class="inpCircleRadius" id="radius" value="3000" placeholder="Radius" />
            <br />
            <input type="button" value="Load 2GIS Map" onclick="Load2GISMap()" />
            <br />
             <div id="2GISMap" style="width:500px; height:400px"></div>
        </div>
    </form>
</body>
</html>
