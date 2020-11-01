<%@ Page Language="C#" AutoEventWireup="true" CodeFile="2GISPlaces.aspx.cs" Inherits="GMapVs2GIS" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>2GIS vs GMaps</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
    <script src="https://maps.api.2gis.ru/2.0/loader.js?pkg=full"></script>

    <script src="Resources/js/common.js"></script>
    <script src="Resources/js/2GIS.js"></script>
    <script>

        var selectedAreaValue;
        var selectedAreaText;
        var selectedAreaObject;
        var latitude;
        var longitude;
        var radius;
        var textToSearch;

        $(document).ready(function () {
            BindAreas();

            $('#cmbArea').change(function () {
                selectedAreaValue = $("#cmbArea option:selected").val();
                selectedAreaText = $("#cmbArea option:selected").text();
                selectedAreaObject = getAreaByAreaId(parseInt(selectedAreaValue));
                $("#latitude").val(selectedAreaObject.Latitude);
                $("#longitude").val(selectedAreaObject.Longitude);
                $("#radius").val(selectedAreaObject.Radius);
                latitude = $("#latitude").val();
                longitude = $("#longitude").val();
                radius = $("#radius").val();
            });
        });

        function Load2GISMap() {
            if (validateFields()) {
                debugger
                textToSearch = $("#txtBuildingSearch").val();
                GeoCodeAddress2GIS(textToSearch, latitude, longitude, radius);
            }
        }


        function GetAreas() {
            var jqxhr = $.get("http://catalog.api.2gis.ru/2.0/geo/list?key=ruydfq9322&region_id=99&type=adm_div.district&fields=items.geometry.selection", function (response) {
                debugger
                if (response.result === undefined || response.result.items.length == 0) {
                    alert('Result not found');
                    return;
                }

                //var center = response.result.items[0].geometry.centroid
                //var replacedString = response.result.items[0].geometry.centroid.replace("POINT(", "").replace(")", "");
                //var splitString = replacedString.split(' ');
                //LoadGISMap(parseFloat(splitString[1]), parseFloat(splitString[0]));

            }).fail(function (response) {
                alert('failure');
            })
        }

        function validateFields() {
            if ($("#txtBuildingSearch").val() == "") {
                alert('Please enter search text');
                return false;
            }

            if (selectedAreaValue == "0" || selectedAreaValue == undefined) {
                alert('Please select area');
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div style="text-align: center">
                <div>
                    <h2>2GIS vs GMAPs</h2>
                </div>
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
            </div>
            <div class="col-6" style="float: left;">
                <input type="button" value="Load 2GIS Map" onclick="Load2GISMap()" />
                <input type="button" value="Load 2GIS Map" onclick="GetAreas()" />
                <br />
                <div id="2GISMap" style="width: 600px; height: 400px"></div>
                Full Address:
                <input type="text" id="txt2GISRevereseGeocoded" style="width: 600px" /><br />
                Building:
                <input type="text" id="txt2GISBuilding" style="width: 600px" /><br />
                Street:
                <input type="text" id="txt2GISStreet" style="width: 600px" />
            </div>


        </div>
    </form>
</body>
</html>
