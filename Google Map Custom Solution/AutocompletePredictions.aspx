<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AutocompletePredictions.aspx.cs" Inherits="Default4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        #map {
            height: 100%;
        }

        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        .autocomplete-input-container {
            position: absolute;
            z-index: 1;
            width: 100%;
        }

        .autocomplete-input {
            text-align: center;
        }

        .my-input-autocomplete {
            box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.16), 0 0 0 1px rgba(0, 0, 0, 0.08);
            font-size: 15px;
            border-radius: 3px;
            border: 0;
            margin-top: 10px;
            width: 290px;
            height: 40px;
            text-overflow: ellipsis;
            padding: 0 1em;
        }

            .my-input-autocomplete:focus {
                outline: none;
            }

        .autocomplete-results {
            margin: 0 auto;
            right: 0;
            left: 0;
            position: absolute;
            display: none;
            background-color: white;
            width: 320px;
            padding: 0;
            list-style-type: none;
            margin: 0 auto;
            border: 1px solid #d2d2d2;
            border-top: 0;
            box-sizing: border-box;
        }

        .autocomplete-item {
            padding: 5px 5px 5px 35px;
            height: 26px;
            line-height: 26px;
            border-top: 1px solid #d9d9d9;
            position: relative;
            white-space: nowrap;
            text-overflow: ellipsis;
            overflow: hidden;
        }

        .autocomplete-icon {
            display: block;
            position: absolute;
            top: 7px;
            bottom: 0;
            left: 8px;
            width: 20px;
            height: 20px;
            background-repeat: no-repeat;
            background-position: center center;
        }

            .autocomplete-icon.icon-localities {
                background-image: url(https://images.woosmap.com/icons/locality.svg);
            }

        .autocomplete-item:hover .autocomplete-icon.icon-localities {
            background-image: url(https://images.woosmap.com/icons/locality-selected.svg);
        }

        .autocomplete-item:hover {
            background-color: #f2f2f2;
            cursor: pointer;
        }

        .autocomplete-results::after {
            content: "";
            padding: 1px 1px 1px 0;
            height: 18px;
            box-sizing: border-box;
            text-align: right;
            display: block;
            background-image: url(https://maps.gstatic.com/mapfiles/api-3/images/powered-by-google-on-white3_hdpi.png);
            background-position: right;
            background-repeat: no-repeat;
            background-size: 120px 14px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
</head>
<body>


    <div>

        <form id="form1" runat="server">
            <asp:DropDownList ID="cmbEmirate" runat="server">
                <asp:ListItem>Dubai</asp:ListItem>
                <asp:ListItem>Abu Dhabi</asp:ListItem>
                <asp:ListItem>Sharjah</asp:ListItem>
                <asp:ListItem>Ajman</asp:ListItem>
            </asp:DropDownList>

            <div class="autocomplete-input-container">
                <div class="autocomplete-input">
                    <input id="my-input-autocomplete2" class="my-input-autocomplete" placeholder="AutocompleteService" autocomplete="off" />
                </div>
                <ul class="autocomplete-results">
                </ul>
            </div>

        </form>
    </div>




    <div id="map"></div>

    <!-- Replace the value of the key parameter with your own API key. -->
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCUkugsILXkVRYWgOqRv0vlo4Z6A4ngMTs&language=en&libraries=places&callback"></script>
    <script>
        function debounce(func, wait, immediate) {
            let timeout;
            return function () {
                let context = this,
                  args = arguments;
                let later = function () {
                    timeout = null;
                    if (!immediate) func.apply(context, args);
                };
                let callNow = immediate && !timeout;
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
                if (callNow) func.apply(context, args);
            };
        }

        function initAutocomplete() {
            let sessionToken = new google.maps.places.AutocompleteSessionToken();

            //let map = new google.maps.Map(document.getElementById('map'), {
            //    center: {
            //        lat: 48,
            //        lng: 4
            //    },
            //    zoom: 4,
            //    disableDefaultUI: true
            //});

            // Create the search box and link it to the UI element.
            let inputContainer = document.querySelector('autocomplete-input-container');
            let autocomplete_results = document.querySelector('.autocomplete-results');
            let service = new google.maps.places.AutocompleteService();
            let autocomplete_input = document.getElementsByClassName('my-input-autocomplete')[0];
            //            let serviceDetails = new google.maps.places.PlacesService(map);
            //let marker = new google.maps.Marker({
            //    map: map
            //});
            let displaySuggestions = function (predictions, status) {
                if (status != google.maps.places.PlacesServiceStatus.OK) {
                    autocomplete_results.style.display = 'none';
                    //                    alert(status);
                    return;
                }
                let results_html = [];
                predictions.forEach(function (prediction) {
                    var formattedText = prediction.description.replace(new RegExp("(" + autocomplete_input.value + ")", "gi"), '<b>$1</b>');
                    results_html.push(`<li class="autocomplete-item" data-type="place" data-place-id=${prediction.place_id}><span class="autocomplete-icon icon-localities"></span><span style='display:none' class='PlaceName'>${prediction.structured_formatting.main_text}</span><span class="autocomplete-text">${formattedText}</span></li>`);
                });
                autocomplete_results.innerHTML = results_html.join("");
                autocomplete_results.style.display = 'block';
                let autocomplete_items = autocomplete_results.querySelectorAll('.autocomplete-item');
                for (let autocomplete_item of autocomplete_items) {
                    autocomplete_item.addEventListener('click', function () {
                        let prediction = {};
                        const selected_text = this.querySelector('.autocomplete-text').textContent;
                        const place_id = this.getAttribute('data-place-id');
                        let request = {
                            placeId: place_id
                        };

                        autocomplete_input.value = this.querySelector('.PlaceName').textContent
                        //                        autocomplete_input.value = selected_text;
                        autocomplete_results.style.display = 'none';
                    })
                }
            };

            autocomplete_input.addEventListener('input', debounce(function () {
                let value = this.value;
                value.replace('"', '\\"').replace(/^\s+|\s+$/g, '');
                if (value !== "") {
                    service.getPlacePredictions({
                        //                        input: "Abu Dhabi" + " " + value,
                        input: value,
                        componentRestrictions: { country: 'AE' },
                        sessionToken: sessionToken
                    }, displaySuggestions);
                } else {
                    autocomplete_results.innerHTML = '';
                    autocomplete_results.style.display = 'none';
                }
            }, 150));

           

            //autocomplete_input.addEventListener('blur', function () {

            //    autocomplete_results.innerHTML = '';
            //    autocomplete_results.style.display = 'none';
            //});
        }
        document.addEventListener("DOMContentLoaded", function (event) {
            initAutocomplete();
        });
    </script>
</body>
</html>
