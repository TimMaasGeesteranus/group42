using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using HoPla_API.Context;
using Microsoft.EntityFrameworkCore;



FirebaseApp.Create(new AppOptions()
{
    Credential = GoogleCredential.FromFile("ho-pla-firebase-adminsdk-c5e9h-e5364105ff.json"),
});

// This registration token comes from the client FCM SDKs.
var registrationToken = "dBNrciFAQQaneZin1SZdGM:APA91bGt3iW5ss5gurMCw0qSU0bci7QvQKHvFL_q1NQArq4BZ1GGUbGVPdl2ecd76_pbNKcCAlau1WsDa9Q8pkPBmk9P-IImvU4Xa3-4xhY_rsnoIk-o4oZWg8b8kQuf8eY0SgMXmkeZ";

// See documentation on defining a message payload.
var message = new Message()
{
    Notification = new Notification
    {
        Title = "Test Notification",
        Body = "This is a test notification"
    },
    Token = registrationToken,
};


// Send a message to the device corresponding to the provided
// registration token.
string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
// Response is a message ID string.
Console.WriteLine("Successfully sent message: " + response);



var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
