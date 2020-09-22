<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AutocompleteSearchBox.aspx.cs" Inherits="Default5" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:DropDownList ID="cmbEmirate" runat="server">
                <asp:ListItem>Dubai</asp:ListItem>
                <asp:ListItem>Abu Dhabi</asp:ListItem>
                <asp:ListItem>Sharjah</asp:ListItem>
                <asp:ListItem>Ajman</asp:ListItem>
            </asp:DropDownList>
            <label for="searchTextField">Please Insert an address:</label>
            <br>
            <input id="searchTextField" type="text" size="50">
        </div>

        <script>

            $(document).ready(function () {


                var input = document.getElementById('searchTextField');
                var options = {
                    componentRestrictions: {
                        country: 'AE'
                    }
                };

                var autocomplete = new google.maps.places.Autocomplete(input, options);

                $(input).on('input', function () {
                    var str = input.value;
                    prefix = '';
                    var prefix = $("#cmbEmirate option:selected").val() +", ";
                    debugger
                    if (str.indexOf(prefix) == 0) {
                        console.log(input.value);
                    } else {
                        if (prefix.indexOf(str) >= 0) {
                            input.value = prefix;
                        } else {
                            input.value = prefix + str;
                        }
                    }

                });

                google.maps.event.addListener(autocomplete, 'place_changed', function () {
                    var place = autocomplete.getPlace();
                    var lat = place.geometry.location.lat();
                    var long = place.geometry.location.lng();
                //    alert(lat + ", " + long);

                });

            });
        </script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&language=en&libraries=places"></script>
    </form>
</body>
</html>
