// admin.js

// runs when admin page is rendered

$(function ()
    {
    // 1. GET /templates/admin_page.div, insert into <body>
    $.ajax (
        {
        url:   "/templates/admin_page.div",  // html to be inserted into "body"
        async: false,
        type:  "GET",
        error: function (xhr, status, error)
            {
            alert ("ajax() error on GET /templates/admin_page.div" + "\n" +
                   "status: " + status + "\n" +
                   "error: "  + error);
            },
        success: function (admin_page_div)
            {
            // alert ("ajax() success on GET /templates/admin_page.div");

            // insert the admin_page.div
            $("body").html (admin_page_div);
            }
        });

    // 2. GET /v1/directors.json, insert into 3 "director" dropdowns
    populateDirectorDropdowns ();

    // 3. Create button triggers-to-functions
    $("#admin-add-director-button").click (function ()    { adminAddDirector ();    });
    $("#admin-delete-director-button").click (function () { adminDeleteDirector (); });
    $("#admin-add-movie-button").click (function ()       { adminAddMovie ();       });
    $("#admin-delete-movie-button").click (function ()    { adminDeleteMovie ();    });

    // 4. Create director dropdown 'change' trigger to populate associated movie dropdown
    hookDeleteMovieDirectorDropdown ();
    });

function hookDeleteMovieDirectorDropdown ()
    {
    $("#admin-delete-movie-director").change (function ()
        {
        // Extract new director_name from the text box
        var director_name = $("#admin-delete-movie-director").find("option:selected").text ();

        // alert ("director_name: " + director_name);

        // Populate using the selected director_name
        populateMovieDropdown (director_name);
        });
    }

/******************************************************************************/
/* populate-dropdown functions                                                */
/******************************************************************************/

function populateDirectorDropdowns ()
    {
    $.ajax (
        {
        url:   "/v1/directors.json",
        async: false,
        type:  "GET",
        error: function (xhr, status, error)
            {
            alert ("ajax() error on GET /v1/directors.json" + "\n" +
                   "status: " + status + "\n" +
                   "error: "  + error);
            },
        success: function (data)
            {
            // alert ("ajax() success on GET /v1/directors/json" + "\n" +
            //        "data: " + JSON.stringify (data));

            // (ex) data = { "rc": rc, "message": message, "data": { "directors": director_list }};

            var rc            = data.rc;
            var message       = data.message;
            var directors     = data.data.directors;
            var options       = "";
            var director_name = "";

            // alert ("rc: "        + rc      + "\n" +
            //        "message: "   + message + "\n" +
            //        "directors: " + directors);

            // Hardcode 1st dropdown option
            options += "<option disabled selected>Choose director...</option>";

            // Get each director name
            for (var i = 0; i < directors.length; i++)
                {
                // ex: Scorsese
                director_name = directors [i].name;

                // alert (director_name);

                // ex: <option>Scorsese</option>
                options += "<option value='" + director_name + "'>" + director_name + "</option>";
                }

            // alert ("options: " + options);

            // Insert "options" (i.e. director names) into director dropdowns
            $("#admin-delete-director-director").empty ();          // clear
            $("#admin-delete-director-director").append (options);  // append options

            $("#admin-add-movie-director").empty ();
            $("#admin-add-movie-director").append (options);

            $("#admin-delete-movie-director").empty ();
            $("#admin-delete-movie-director").append (options);
            }
        });
    }

function populateMovieDropdown (director_name)
    {
    var url = "/v1/directors/" + director_name + "/movies.json";

    // GET /v1/directors/{director_name}/movies.json, insert into associated movie dropdown
    $.ajax (
        {
        url:   url,
        async: false,
        type:  "GET",
        error: function (xhr, status, error)
            {
            alert ("ajax() error on GET " + url + "\n" +
                   "status: " + status + "\n" +
                   "error: "  + error);
            },
        success: function (data)
            {
            // alert ("ajax() success on GET " + url + "\n" +
            //        "data: " + JSON.stringify (data));

            // (ex) data =
            // { "rc": 0, "message": "movies found: 2",
            //   "data": { "movies": [ { "moviejson": "Get_Out_2017.json", "moviename": "Get_Out_2017" },
            //                         { "moviejson": "Us_2019.json",      "moviename": "Us_2019" }]}}

            var rc         = data.rc;
            var message    = data.message;
            var movies     = data.data.movies;
            var options    = "";
            var movie_name = "";

            // alert ("rc: "      + rc      + "\n" +
            //        "message: " + message + "\n" +
            //        "movies: "  + movies);

            // Hardcode 1st dropdown option
            options += "<option disabled selected>Choose movie...</option>";

            // Get each movie name
            for (var i = 0; i < movies.length; i++)
                {
                // ex: Get_Out_2017
                movie_name = movies [i].moviename;

                // ex: <option>Get_Out_2017</option>
                options += "<option value='" + movie_name + "'>" + movie_name + "</option>";
                }

            // alert ("options: " + options);

            // Insert "options" (i.e. movie names) into associated movie dropdown
            $("#admin-delete-movie-movie").empty ();          // clear
            $("#admin-delete-movie-movie").append (options);  // append options
            }
        });
    }

/******************************************************************************/
/* button actions                                                             */
/******************************************************************************/

function adminAddDirector ()
    {
    // CODE COMPLETE, WORKING

    // Extract new director_name from the text box
    var director_name = $("#admin-add-director-director").val ();

    if (director_name == "")
        {
        alert ("ERROR: please enter a director first");
        }
    else
        {
        // alert ("director_name: " + director_name);

        var jsonOut = { "_id" : director_name, "name" : director_name, "description" : "" };

        // ex: /v1/directors/Landis.json
        var url = "/v1/directors/" + director_name + ".json";

        $.ajax (
            {
            url:   url,
            async: false,
            type:  "PUT",
            data:  jsonOut,
            dataType: "json",
            error: function (xhr, status, error)
                {
                alert ("ajax() error on PUT " + url + "\n" +
                       "status: " + status + "\n" +
                       "error: "  + error);
                },
            success: function (data)
                {
                alert ("ajax() success on PUT " + url + "\n" +
                       "data: " + JSON.stringify (data));

                // Re-populate the 3 director dropdowns
                populateDirectorDropdowns ();
                }
            });
        }
    }

function adminDeleteDirector ()
    {
    // CODE COMPLETE, WORKING

    var director_name = $("#admin-delete-director-director").find("option:selected").text ();

    if (director_name == "Choose director...")
        {
        alert ("ERROR: please choose a director first");
        }
    else
        {
        // alert ("director_name: " + director_name);

        // JSON_OUT="{ \"directorName\": \"Landis\" }"
        // curl --request DELETE \
        //      --header 'Content-Type: application/json' \
        //      --data "$JSON_OUT" \
        //      http://localhost:8080/v1/directors/Landis.json

        var jsonOut = { "directorName" : director_name };

        // ex: /v1/directors/Landis.json
        var url = "/v1/directors/" + director_name + ".json";

        $.ajax (
            {
            url:   url,
            async: false,
            type:  "DELETE",
            data:
                {
                "jsonOut": jsonOut
                },
            dataType: "json",
            error: function (xhr, status, error)
                {
                alert ("ajax() error on DELETE " + url + "\n" +
                       "status: " + status + "\n" +
                       "error: "  + error);
                },
            success: function (data)
                {
                alert ("ajax() success on DELETE " + url + "\n" +
                       "data: " + JSON.stringify (data));

                // Re-populate the 3 director dropdowns
                populateDirectorDropdowns ();
                }
            });
        }
    }

function adminAddMovie ()
    {
    // TODO

    var director_name = $("#admin-add-movie-director").find("option:selected").text ();

    if (director_name == "Choose director...")
        {
        alert ("ERROR: please choose a director first");
        }
    else
        {
        // Extract new movie_name from the text box
        var movie_name = $("#admin-add-movie-movie").val ();

        if (movie_name == "")
            {
            alert ("ERROR: please enter a movie first");
            }
        else
            {
            alert ("director_name: " + director_name + "\n" +
                   "movie_name: "    + movie_name);
            }
        }
    }

function adminDeleteMovie ()
    {
    // CODE COMPLETE, WORKING

    var director_name = $("#admin-delete-movie-director").find("option:selected").text ();

    if (director_name == "Choose director...")
        {
        alert ("ERROR: please choose a director first");
        }
    else
        {
        var movie_name = $("#admin-delete-movie-movie").find("option:selected").text ();

        if (movie_name == "Choose movie...")
            {
            alert ("ERROR: please choose a movie first");
            }
        else
            {
            // alert ("director_name: " + director_name + "\n" +
            //        "movie_name: "    + movie_name);

            // JSON_OUT="{ \"name\": \"Animal_House_1978\" }"
            // curl --request DELETE \
            //      --header 'Content-Type: application/json' \
            //      --data "$JSON_OUT" \
            //      http://localhost:8080/v1/directors/Landis/movies.json

            // ex: /v1/directors/Landis/movies.json
            var url = "/v1/directors/" + director_name + "/movies.json";

            $.ajax (
                {
                url:   url,
                async: false,
                type:  "DELETE",
                data:  { "name": movie_name },
                dataType: "json",
                error: function (xhr, status, error)
                    {
                    alert ("ajax() error on DELETE " + url + "\n" +
                           "status: " + status + "\n" +
                           "error: "  + error);
                    },
                success: function (data)
                    {
                    alert ("ajax() success on DELETE " + url + "\n" +
                           "data: " + JSON.stringify (data));

                    // Populate using the director_name
                    populateMovieDropdown (director_name);
                    }
                });
            }
        }
    }

