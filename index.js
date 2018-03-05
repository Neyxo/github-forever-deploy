var execFile = require('child_process').execFile;
var githubhook = require('githubhook');

var github = githubhook({
    host: '0.0.0.0',    //You most likely do not have to change this
    port: 4200,         //Your prefered server port
    path: '/gitback',   //Your gitback path
    secret: 'secret',   //Your GitHub webhook secret key
    logger: console,    //Your prefered logger
});

//Additional options on execution
var execOptions = {
	maxBuffer: 4096 * 1024 //Increase max buffer size
};

//STARTUP
console.log("STARTUP - executing deploy.sh");
execFile('/var/www/mywebsite.com/deploy/deploy.sh', execOptions, function(error, stdout, stderr) {
	if(error)
	{
		console.log(error)
	}
	else{
		console.log("STARTUP FINISHED - successfully executed deploy.sh on startup")
	}
});

//IDLE
github.listen();

//TRIGGER
github.on('my-repository', function (data) {
    console.log("UPDATE - executing update.sh (webhook event)");

    //Additional options on execution
    var execOptions = {
        maxBuffer: 4096 * 1024 // Increase max buffer
    };

    //UPDATE EVENT
    //You can make a separate file for updates or just use the same file as above "deploy.sh"
    execFile('/var/www/mywebsite.com/deploy/update.sh', execOptions, function(error, stdout, stderr) {
        if( error )
        {
            console.log(error)
        }
        else{
            console.log("UPDATE FINISHED - succesfully executed update.sh on webhook event")
        }
    });
});
