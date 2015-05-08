var http = require('http');
var querystring = require('querystring');
var Buffer = require('buffer').Buffer;
var moment = require('cloud/moment');
   
var twilio_cred = require('cloud/config').keys.twilio;
var mailjet_cred = require('cloud/config').keys.mailjet;
var InteractiveIntel_cred = require('cloud/config').keys.InteractiveIntelligence;
   
var emailTemp = require('cloud/assets').email;
var smsTemp = require('cloud/assets').SMS;
var phoneTemp = require('cloud/assets').Phone;
   
var client = require('twilio')(twilio_cred.AccountSID, twilio_cred.AuthToken);
   
var fillTemp = function (temp, params) {
    var arr = temp.split('||');
    var new_arr = arr.map(function (chunk) {
        return params[chunk] ? params[chunk].trim() : chunk;
    });
    return new_arr.join('');
};
   
var addGender = function (params) {
    if (params.gender == 'male'){
        params['they'] = 'he';
        params['they have'] = 'he has';
        params['they are'] = 'he is';
        params['their'] = 'his';
        params['them'] = 'him';
    } else if (params.gender == 'female'){
        params['they'] = 'she';
        params['they have'] = 'she has';
        params['they are'] = 'she is';
        params['their'] = 'her';
        params['them'] = 'her';
    }
    return params;
};
   
   
///////////////////////////
///// PARSE FUNCTIONS /////
///////////////////////////

Parse.Cloud.define("SMS", function(request, response) {
    var params = addGender(request.params);
    var phone_num = request.params.phonenum;
    var message = fillTemp(smsTemp, params);
    if (message.length > 160) {
        //console.log("TOOLONG "+message);
        message = smsTemp;
    }
    if (!phone_num || !message){
        response.error("Missing neccessary params");
    } else {
        // Send an SMS message
        client.sendSms({
            to:'+1' + phone_num,
            from: twilio_cred.number,
            body: message
        }, function(err, responseData) {
                if (err) {
                    console.log(err);
                    response.error(err);
                } else {
                    console.log(responseData.from);
                    console.log(responseData.body);
                    response.success("SMS sent");
                }
            }
        );
    }
   
});
   
Parse.Cloud.define("Email", function(request, response) {
    var params = request.params;
    var authorization = new Buffer(mailjet_cred.APIKey + ':' + mailjet_cred.SecretKey, 'utf8').toString('base64');
    var email = request.params.email;
    var subject = fillTemp(emailTemp.subject, params);
   
    //Use First names for the body
    params.username = params.username.split(' ')[0];
    params.friendname = params.friendname.split(' ')[0];
    params.time = params.time + (params.time == 1 ? ' minute' : ' minutes');
   
    params = addGender(params);
    var message = fillTemp(emailTemp.body, params);
   
   
    if (!email || !subject || !message){
        response.error("Missing neccessary params");
    } else {
        var body = querystring.stringify({
            from: mailjet_cred.Sender,
            to: email,
            subject: subject,
            html: message
        });
        Parse.Cloud.httpRequest({
            method: 'POST',
            url: 'https://api.mailjet.com/v3/send/message',
            headers: {
                'Authorization': 'Basic ' + authorization,
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: body,
            success: function(httpResponse) {
                console.log(httpResponse.text);
                response.success('Email sent');
            },
            error: function(httpResponse) {
                console.error('Request failed with response code ' + httpResponse.status);
                response.error('Request failed with response code ' + httpResponse.status);
            }
        });
   
    }
});
   
Parse.Cloud.define("PhoneCall", function(request, response) {
    var params = addGender(request.params);
    params.time = params.time + (params.time == 1 ? ' minute' : ' minutes');
    var message = fillTemp(phoneTemp, params);
   
    var data= {"number":request.params.phonenum, "message":message};
    console.log(data);
   
    Parse.Cloud.httpRequest({
        method: 'POST',
        url:  "http://hackathonapi.inin.com/api" + InteractiveIntel_cred.AppID +"/call/callandplaytts",
        headers: {
            'Api-Key': InteractiveIntel_cred.AppKey,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data),
        success: function(httpResponse) {
            console.log(httpResponse.text);
            response.success('Phone called');
        },
        error: function(httpResponse) {
            console.error('Request failed with response code ' + httpResponse.status);
            response.error('Request failed with response code ' + httpResponse.status);
        }
    });
});

/*
Parse.Cloud.define("mailgun", function(request, response) {
    var Mailgun = require('mailgun');
    Mailgun.initialize('sandbox1d7324b883a04f6c9a3ed6df1e3da325.mailgun.org', 'key-22605f9f2f2dafb41700875eccf3ceff');
 
    Mailgun.sendEmail({
      to: "aubakirova.m.m@gmail.com",
      from: "Journey <mailgun@journey-hackillinois.parse.com>",
      subject: "Hello from Cloud Code!",
      text: "Using Parse and Mailgun is great!"
    }, {
      success: function(httpResponse) {
        console.log(httpResponse);
        response.success("Email sent!");
      },
      error: function(httpResponse) {
        console.error(httpResponse);
        response.error("Uh oh, something went wrong");
      }
    });
});
*/
 
Parse.Cloud.define("MailGunEmail", function(request, response) {
    var params = request.params;
    var email = request.params.email;
    var subject = fillTemp(emailTemp.subject, params);
    
    //Use First names for the body
    params.username = params.username.split(' ')[0];
    params.friendname = params.friendname.split(' ')[0];
    params.time = params.time + (params.time == 1 ? ' minute' : ' minutes');
    
    params = addGender(params);
    var message = fillTemp(emailTemp.body, params);
    
    
    if (!email || !subject || !message){
        response.error("Missing neccessary params");
    } else {
        var Mailgun = require('mailgun');
        Mailgun.initialize('sandbox1d7324b883a04f6c9a3ed6df1e3da325.mailgun.org', 'key-22605f9f2f2dafb41700875eccf3ceff');
 
        Mailgun.sendEmail({
          to: email,
          from: "Journey <mailgun@journey-hackillinois.parse.com>",
          subject: subject,
          html: message
        }, {
          success: function(httpResponse) {
            console.log(httpResponse);
            response.success("Email sent!");
          },
          error: function(httpResponse) {
            console.error(httpResponse);
            response.error("Uh oh, something went wrong");
          }
        });
    
    }
});

//Makes Journey.active = false
Parse.Cloud.define("endJourney", function(request, response) {
    Parse.Cloud.useMasterKey();
    var Journey = Parse.Object.extend("Journey");
    var query = new Parse.Query(Journey);

    query.get(request.params.journeyId, { //Pass in the objectId of the journey
      success: function(journey) {
        journey.set("active", false);
        journey.save(null, {
            success: function (journey) { response.success("Successfully recorded inactive journey."); },
            error: function (journey, error) {
                response.error("Error: " + error.code + " " + error.message);
            }
        });
      },
      error: function(journey, error) {
        response.error("Error: " + error.code + " " + error.message);
      }
    });


});

//////////////////////
///// PARSE JOBS /////
//////////////////////
  
Parse.Cloud.job("checkJourneys", function(request, repsonse) {
    Parse.Cloud.useMasterKey();
    var Journey = Parse.Object.extend("Journey");
    var query = new Parse.Query(Journey);
    query.equalTo("active", true);
    query.each(function(journey) {
        var duration = journey.get('duration');
        var start = journey.get('start');
          
        var end = moment(start).add(duration,'s');
        var end_bound = moment(start).add(duration + 60,'s');
        var now = moment();
  
        var between = now.isBetween(end,end_bound);
        //if between == true
        //push notification to user device
        //if no response, contact people
  
        console.log(journey.id + ' - ' + end.format() + ' - ' + end_bound.format() + ' - ' + now.format() + ' - ' + between);
  
    }).then(function() {
        repsonse.success("Checked Journeys successfully.");
    }, function(error) {
        repsonse.error("Error: " + error.code + " " + error.message);
    });
});
