// Module ... server.js
// Desc ..... Nodejs/express reference REST api

/******************************************************************************/
/* http status return codes:                                                  */
/******************************************************************************/

//   . 200 OK           Request successful
//   . 201 OK           Resource created successfully
//   . 204 OK           Resource deleted successfully  // response.status (204).send (data);
//   . 400 Bad Request  Invalid request                // specify error in return payload: ("Unrecognized URI")
//   . 404 Not found    Resource not found             // response.status (404, "The task is not found").send ();
//   . 500 Error        Internal server error

/******************************************************************************/
/* require                                                                    */
/******************************************************************************/

// Required libs
var async      = require ("async");
var bodyParser = require ("body-parser");
var datetime   = require ("node-datetime");
var express    = require ("express");
var formidable = require ("formidable");
var fs         = require ("fs");
var glob       = require ("glob");
var helpers    = require ("./handlers/helpers.js");
var mysql      = require ("mysql");
var path       = require ("path");
var util       = require ("util");

/******************************************************************************/
/* log to logfile (create and append)                                         */
/******************************************************************************/

// false: do not log to logfile
// true:  log to logfile
var logToFile = true;
var logfile   = "./_server.log";

if (logToFile)
    {
    // Cause console.log() to log to console AND logfile
    var log_file   = fs.createWriteStream (logfile, {flags : "w"});
    var log_stdout = process.stdout;
    console.log = (d) =>
        {
        log_file.write (util.format (d) + "\n");
        log_stdout.write (util.format (d) + "\n");
        }
    }

// Display current time
var dt = datetime.create ();
console.log ("server.js.  Started: " + dt.format ("Y-m-d H:M:S"));
console.log ("");

/******************************************************************************/
/* express routing                                                            */
/******************************************************************************/

// Create express router
var app = express ();
var v1  = express.Router ();
var v2  = express.Router ();

/******************************************************************************/
/* middleware                                                                 */
/******************************************************************************/

// Setup middleware
app.use (express.static (__dirname + "/../static"));
app.use (bodyParser.json ());
app.use (bodyParser.urlencoded ({ extended: true }));

// Route /v1 and / URIs to v1-prefixed functions
app.use (["/v1", "/"], v1);

// Route /v2 URIs to v2-prefixed functions
app.use ("/v2", v2);

// Directory from where to serve static assets (html, css, js, jpg, etc.)
app.use (express.static (__dirname + "/../static"));

/******************************************************************************/
/* listen for inbound requests                                                */
/******************************************************************************/

// Listen for inbound requests on port 8080
app.listen (8080);

/******************************************************************************/
/* mysql startup, initialization                                              */
/******************************************************************************/

var db = mysql.createConnection (
    {
    host     : 'localhost',
    user     : 'nsimon',
    password : 'cwb206',
    database : 'movieapp'
    });

db.connect ();

/******************************************************************************/
/* mongodb startup, initialization                                            */
/******************************************************************************/

var m_db        = "";  // database
var m_directors = "";  // m_db.collection ("directors")
var m_movies    = "";  // m_db.collection ("movies")
        
/******************************************************************************/
/* ROUTES: vi.all()                                                           */
/******************************************************************************/

v1.all ("*", (request, response, next) =>
    {
    // ALL v1 requests route through here
    v1_logInboundRequest (request);

    // Chain to requested endpoint route
    next ();
    });

/******************************************************************************/
/* BROWSER ROUTES: v1.get()                                                   */
/******************************************************************************/

v1.get ("/", (request, response) =>
    {
    // EX:      /
    // DESC:    redirect to /pages/home
    // RETURNS: n/a
    // ERROR:   n/a

    response.redirect ("/pages/home");
    response.end ();
    });

v1.get ([ "/pages/:page_name",
          "/pages/:page_name/:director",
          "/pages/:page_name/:director/:movie" ], (request, response) =>
    {
    // EX:      /
    //          /pages/home
    //          /pages/director/Quentin
    //          /pages/director/Quentin/Pulp_Fiction
    // DESC:    home page of all directors
    // RETURNS: html

    // ex: Quentin (optional)
    var director = request.params.director;
    console.log ("director .... " + director);

    // ex: Pulp_Fiction (optional)
    var movie = request.params.movie;
    console.log ("movie ....... " + movie);

    // ex: home
    var page_name = request.params.page_name;
    console.log ("page_name ... " + page_name);

    console.log ("");

    // read basic.html template
    fs.readFile ("../static/templates/basic.html", (err, contents) =>
        {
        if (err)
            {
            // return json error
            var rest_rc = 500;
            var message = "Internal server error";
            response.writeHead (rest_rc, { "Content-Type" : "application/json" });
            response.end (JSON.stringify ({ error: rest_rc, message: message }) + "\n");
            }
        else
            {
            // return html content
            var rest_rc = 200;
            contents = contents.toString ("utf8");

            if (typeof movie !== "undefined")
                {
                // console.log ("We have a movie!");
                }

            // if movie was specified, use "movie"
            // else use :page name (either "home" or "director")
            var page_type = (typeof movie !== "undefined") ? "movie" : page_name;

            // resolves to page <title>
            contents = contents.replace ("{{ PAGE_NAME }}",  page_type);

            // resolves to a client-js script specified in the web page
            // ex: home.js, director.js, or movie.js
            contents = contents.replace ("{{ PAGE_TITLE }}", page_type);

            response.writeHead (rest_rc, { "Content-Type": "text/html" });
            response.end (contents);
            }
        });
    });

/******************************************************************************/
/* API ROUTES: v1.get()                                                       */
/******************************************************************************/

v1.get ([ "/directors.json",
          "/directors.xml" ], (request, response) =>
    {
    // EX:      /directors.json
    // DESC:    get all directors
    // RETURNS: json

    // mysql: get director names
    db.query ("SELECT name FROM directors;", function (err, directors)
        {
        var rc;
        var jsonOut;
        var director_list = [];

        if (err)
            {
            rc = 1;
            message = "Unable to get directors from mysql";
            }
        else
            {
            rc = 0;
            message = "Directors found: " + directors.length;

            // push a json key:value pair for each director
            for (var i = 0; i < directors.length; i++)
                {
                console.log ("director: " + directors [i].name);
                director_list.push ({ "name": directors [i].name });
                };
            }

        // return json response
        jsonOut = { "rc": rc, "message": message, "data": { "directors": director_list }};
        response.setHeader ("Content-Type", "application/json");
        response.end (JSON.stringify (jsonOut));
        });
    });

v1.get ([ "/directors/:director.json",
          "/directors/:director.xml" ], (request, response) =>
    {
    // EX:      /directors/Quentin.json
    // DESC:    get one director and their movies
    // RETURNS: json

    // ex: Quentin
    var director = request.params.director;
    console.log ("director ....... " + director);

    // mysql: get movies from directror
    db.query ("SELECT * FROM movies WHERE director_name = '" + director + "';", function (err, movies)
        {
        var rc;
        var jsonOut;
        var movie_list = [];

        console.log ("movies found ... " + movies.length);

        if (err)
            {
            rc = 1;
            message = "ERROR: Unable to get movies from mysql";
            }
        else
            {
            rc = 0;
            message = "Movies found: " + movies.length;

            // push a json key:value pair for each movie
            for (var i = 0; i < movies.length; i ++)
                {
                moviename = movies [i].name;                            // ex: Pulp_Fiction_1994

                movie_list.push ({ "moviename": moviename,              // ex: Pulp_Fiction_1994
                                   "moviejpg":  moviename + ".jpg",     // ex: Pulp_Fiction_1994.jpg
                                   "moviejson": moviename + ".json"});  // ex: Pulp_Fiction_1994.json
                };
            }

        // return json response
        jsonOut = { "rc": rc, "message": message, "data": { "director_data": { "director": director, "movies": movie_list }}};
        response.setHeader ("Content-Type", "application/json");
        response.end (JSON.stringify (jsonOut));
        });
    });

v1.get ([ "/directors/:director/movies/:movie.json",
          "/directors/:director/movies/:movie.xml" ], (request, response) =>
    {
    // EX:      /directors/Quentin/movies/Pulp_Fiction_1994.json
    // DESC:    get one movie by a director
    // RETURNS: json

    // ex: Quentin
    var director = request.params.director;

    // ex: Pulp_Fiction_1994
    var movie = request.params.movie;

    // mysql: get movies from directror
    db.query ("SELECT * FROM movies WHERE director_name = '" + director + "';", function (err, movies)
        {
        var rc = 0;
        var message = "";

        console.log ("movies found ... " + movies.length);

        // return json error
        if (err)
            {
            rc = 1;
            message = "ERROR: Unable to find movie in mysql (db error): " + movie;
            console.log (message);
            }
        else if (movies.length == 0)
            {
            rc = 1;
            message = "ERROR: Unable to find movie in mysql (not found error): " + movie;
            console.log (message);
            }
        else
            {
            rc = 0;
            message = "found movie in mysql: " + movie;
            console.log (message);
            }

        // return json response
        var jsonOut = { "rc": rc, "message": message, "data": { "director": director, "moviename": movie, "moviejpg": movie + ".jpg", "moviejson": movie + ".json" }};
        response.setHeader ("Content-Type", "application/json");
        response.end (JSON.stringify (jsonOut));
        });
    });

v1.get ([ "/directors/:director/movies.json",
          "/directors/:director/movies.xml" ], (request, response) =>
    {
    // EX:    /directors/Quentin/movies.json
    // DESC:  get all movies by a director

    // ex: Quentin
    var director = request.params.director;
    console.log ("director ....... " + director);

    // mysql: get movies from directror
    db.query ("SELECT * FROM movies WHERE director_name = '" + director + "';", function (err, movies)
        {
        var rc;
        var jsonOut;
        var movie_list = [];

        console.log ("movies found ... " + movies.length);

        if (err)
            {
            rc = 1;
            message = "ERROR: Unable to get movies from mysql";
            }
        else
            {
            rc = 0;
            message = "movies found: " + movies.length;

            // push a json key:value pair for each movie
            for (var i = 0; i < movies.length; i ++)
                {
                moviename = movies [i].name;                          // ex: Pulp_Fiction_1994

                movie_list.push ({ "moviejson": moviename + ".json",  // ex: Pulp_Fiction_1994.json
                                   "moviename": moviename});          // ex: Pulp_Fiction_1994
                };
            }

        // return json response
        jsonOut = { "rc": rc, "message": message, "data": { "movies": movie_list }};
        response.setHeader ("Content-Type", "application/json");
        response.end (JSON.stringify (jsonOut));
        });
    });

v1.get ("*", (request, response) =>
    {
    // This is the 404 case
    //   . The inbound GET did not match any of the above get() routes
    var rc = 404;
    var message = "page not found: " + request.url;
    console.log (message);
    response.status (rc).send ({ "rc": rc, "message": message });
    });

/******************************************************************************/
/* API ROUTES: v1.put()                                                       */
/******************************************************************************/

v1.put ("/directors/:director.json", (request, response) =>
    {
    // EX:      /v1/directors/Landis.json
    // DESC:    creates one director
    // RETURNS: 200 ok

    var director = request.params.director;
    console.log ("director ......... " + director);

    var directorFolder = "../static/directors/" + director;
    console.log ("directorFolder ... " + directorFolder);

    var name        = request.body.name;
    var description = request.body.description;

    console.log ("name ............. " + name);
    console.log ("description ...... " + description);

    var rc;
    var message;

    if (fs.existsSync (directorFolder))
        {
        rc = 500;
        message = "ERROR: director folder already exists: " + director;
        console.log (message);
        response.status (rc).send ({ "rc": rc, "message": message });
        }
    else
        {
        // create director folder
        fs.mkdirSync (directorFolder);

        if (!fs.existsSync (directorFolder))
            {
            rc = 500;
            message = "ERROR: failed to create director folder";
            console.log (message);
            response.status (rc).send ({ "rc": rc, "message": message });
            }
        else
            {
            console.log ("director folder created successfully");

            var sql = "INSERT INTO directors VALUES ('" + name + "', '" + description + "');";
            console.log ("sql: " + sql);

            // mysql: save new director
            db.query (sql, function (err, rows)
                {
                if (err)
                    {
                    rc = 500;
                    message = "ERROR: failed to save director to mysql";
                    console.log (message);
                    }
                else
                    {
                    rc = 200;
                    message = "successfully saved director to mysql";
                    console.log (message);
                    }

                response.status (rc).send ({ "rc": rc, "message": message });
                });
            }
        }

    console.log ("");
    });

v1.put ("/directors/:director/movies.json", (request, response) =>
    {
    // EX:      /v1/directors/Landis/movies.json
    // DESC:    creates movie for director
    // RETURNS: 200 ok
    // NOTE:    gets called in 2 different ways:
    //          1. To upload poster
    //          2. To save movie fields to mongodb

    var rc;
    var message;

    // ex: Landis
    var director = request.params.director;
    console.log ("director: " + director);

    // ex1: multipart/form-data; boundary=------------------------2049cf9aa2227d89
    // ex2: application/json
    var content_type = request.header ("content-type");
    console.log ("content_type: " + content_type);

    if (content_type == "application/json")
        {
        var director_name = request.body.director_name;
        var name          = request.body.name;
        var description   = request.body.description;

        console.log ("director_name... " + director_name);
        console.log ("name ........... " + name);
        console.log ("description .... " + description);

        var sql = "INSERT INTO movies VALUES ('" + director_name + "', '" + name + "', '" + description + "');";
        console.log ("sql: " + sql);

        // mysql: save new movie
        db.query (sql, function (err, rows)
            {
            if (err)
                {
                rc = 500;
                message = "ERROR: failed to save movie to mysql";
                console.log (message);
                }
            else
                {
                rc = 200;
                message = "successfully saved movie to mysql";
                console.log (message);
                }

            response.status (rc).send ({ "rc": rc, "message": message });
            });
        }
    else
        {
        // receive poster being uploaded

        // ex: ../static/directors/Landis
        var directorFolder = "../static/directors/" + director;
        console.log ("directorFolder: " + directorFolder);

        // if director (folder) does not exist...
        if (!fs.existsSync (directorFolder))
            {
            rc = 500;
            message = "ERROR: director folder does not exist";
            console.log (message);
            response.status (rc).send ({ "rc": rc, "message": message });
            }
        else
            {
            // create a new formidable object
            var form = new formidable.IncomingForm ();

            // appended for each movie created
            var uploadedMovieFiles = [];

            // parse the incoming form
            form.parse (request);

            // the fileBegin event happens when each file upload begins
            form.on ("fileBegin", (name, file) =>
                {
                console.log ("fileBegin()")
                file.path = directorFolder + "/" + file.name;
                });

            // the file event happens when each file completes it's upload
            form.on ("file", (name, file) =>
                {
                console.log ("file(): file uploaded to: " + file.path);
                uploadedMovieFiles.push ({ "file": file.path });
                });

            // the error event
            form.on ("error", () =>
                {
                rc = 500;
                message = "ERROR: upload failed";
                console.log (message);
                response.status (rc).send ({ "rc": rc, "message": message });
                });

            // the end event happens when the upload completes
            form.on ("end", () =>
                {
                console.log ("end()");

                rc = 200;
                message = "successfully saved movie poster";
                console.log (message);
                response.status (rc).send ({ "rc": rc, "message": message });
                });
            }
        }
    });

/******************************************************************************/
/* v1 api - DELETE                                                            */
/******************************************************************************/

v1.delete ("/directors/:director.json", (request, response) =>
    {
    // EX:   /v1/directors/Landis.json
    // DESC: delete Landis and all his movies

    // ex: Landis
    var director = request.params.director;
    console.log ("director: " + director);

    // ex: ../static/directors/Landis
    var directorFolder = "../static/directors/" + director;
    console.log ("directorFolder: " + directorFolder);

    var rc;
    var message;

    // mongodb: remove all movies by director
    m_movies.remove ({ directors_id: director }, function (err, obj)
        {
        if (err)
            {
            rc = 500;
            message = "ERROR: failed to remove all movies by director from mongodb";
            console.log (message);
            response.status (rc).send ({ "rc": rc, "message": message });
            }
        else
            {
            console.log ("successfully removed all movies by director from mongodb");

            // mongodb: remove {director} from directors
            m_directors.remove ({ "_id" : director }, function (err, obj)
                {
                if (err)
                    {
                    rc = 500;
                    message = "ERROR: failed to remove director from mongodb";
                    console.log (message);
                    response.status (rc).send ({ "rc": rc, "message": message });
                    }
                else
                    {
                    console.log ("successfully removed director from mongodb");

                    if (!fs.existsSync (directorFolder))
                        {
                        rc = 200;
                        message = "WARN: directorFolder does not exist: " + directorFolder;
                        console.log (message);
                        response.status (rc).send ({ "rc": rc, "message": message });
                        }
                    else
                        {
                        // get all movie posters under director
                        glob (directorFolder + "/*.jpg", (err, files) =>
                            {
                            if (err)
                                {
                                rc = 500;
                                message = "ERROR: unable to glob() movie posters";
                                console.log (message);
                                }
                            else
                                {
                                for (var i = 0; i < files.length; i++)
                                    {
                                    fs.unlinkSync (files [i]);
                                    console.log ("successful file unlink ..... " + files [i]);
                                    }
        
                                fs.rmdirSync (directorFolder);
                                console.log ("successful folder unlink ... " + directorFolder);
        
                                rc = 200;
                                message = "successfully removed director and their movies";
                                console.log (message);
                                }
        
                            response.status (rc).send ({ "rc": rc, "message": message });
                            });
                        }
                    }
                });
            }
        });
    });

v1.delete ("/directors/:director/movies.json", (request, response) =>
    {
    // EX:   /v1/directors/Landis/movies.json
    // DESC: delete one movie under :director

    // ex: Landis
    var director = request.params.director;
    console.log ("director ......... " + director);

    // ex: animal_house_1978
    var name = request.body.name;
    console.log ("name ............. " + name);

    // ex: ../static/directors/Landis
    var directorFolder = "../static/directors/" + director;
    console.log ("directorFolder ... " + directorFolder);

    var rc;
    var message;

    // mongodb: remove one movie
    m_movies.deleteOne ( { name: name }, function (err, obj)
        {
        if (err)
            {
            rc = 500;
            message = "ERROR: failed to remove one movie by director from mongodb: " + name;
            console.log (message);
            response.status (rc).send ({ "rc": rc, "message": message });
            }
        else
            {
            console.log ("successfully removed one movie by director from mongodb: " + name);

            var posterJpg = (directorFolder + "/" + name + ".jpg");
            console.log ("posterJpg ........ " + posterJpg);

            if (!fs.existsSync (posterJpg))
                {
                rc = 500;
                message = "ERROR: cannot remove posterJpg: file does not exist: " + posterJpg;
                console.log (message);
                response.status (rc).send ({ "rc": rc, "message": message });
                }
            else
                {
                // remove posterJpg
                fs.unlinkSync (posterJpg);

                rc = 200;
                message = "successfully removed: " + name + " (from mongodb), and its poster: " + posterJpg + " (from director folder)";
                console.log (message);
                response.status (rc).send ({ "rc": rc, "message": message });
                }
            }
        });
    });

/******************************************************************************/
/* v1 api - helpers                                                           */
/******************************************************************************/

const v1_logInboundRequest = (request) =>
    {
    console.log ("api version ....... " + "/v1");
    console.log ("request.method .... " + request.method);
    console.log ("request.headers ... " + JSON.stringify (request.headers));
    console.log ("request.body ...... " + JSON.stringify (request.body));
    console.log ("request.params .... " + JSON.stringify (request.params));
    console.log ("request.query ..... " + JSON.stringify (request.query));
    console.log ("request.url ....... " + request.url);
    console.log ("");
    };

/******************************************************************************/
/* v2 api - all                                                               */
/******************************************************************************/

v2.all ("*", (request, response, next) =>
    {
    console.log ("api rev: v2");
    v2_logInboundRequest (request);
    next ();
    });

/******************************************************************************/
/* v2 api - GET                                                               */
/******************************************************************************/

v2.get ("/", (request, response) =>
    {
    // return json
    var message = "Testing v2 api: in v2.get('/')";

    response.writeHead (200, { "Content-Type" : "application/json" });
    response.end (JSON.stringify ({ "rc": 0, "message": message }));
    });

/******************************************************************************/
/* v2 api - helpers                                                           */
/******************************************************************************/

const v2_logInboundRequest = (request) =>
    {
    console.log ("api version ....... " + "/v2");
    console.log ("request.method .... " + request.method);
    console.log ("request.headers ... " + JSON.stringify (request.headers));
    console.log ("request.body ...... " + JSON.stringify (request.body));
    console.log ("request.params .... " + JSON.stringify (request.params));
    console.log ("request.query ..... " + JSON.stringify (request.query));
    console.log ("request.url ....... " + request.url);
    console.log ("");
    }

