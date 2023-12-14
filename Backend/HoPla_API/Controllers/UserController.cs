using FirebaseAdmin.Messaging;
using HoPla_API.Context;
using HoPla_API.Entities;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;
using System.Text;

namespace HoPla_API.Controllers
{

    [ApiController]
    [Route("users")]
    public class UserController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;

        public static string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
                byte[] hashBytes = sha256.ComputeHash(passwordBytes);
                string hashedPassword = BitConverter.ToString(hashBytes).Replace("-", "").ToLower();

                return hashedPassword;
            }
        }

        public static bool VerifyPassword(string loginPassword, string userPassword)
        {
            string hashedPassword = HashPassword(loginPassword);

            return hashedPassword == userPassword;
        }

        public UserController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpGet("getFirst")]
        public async Task<IActionResult> GetTest()
        {

            try
            {
                User user = _appDbContext.Users.First();
                return Ok(user);
            }
            catch (Exception ex)
            {
                return NotFound("No user found");
            }


        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterModel model)
        {
            try
            {
                if (_appDbContext.Users.Any(u => u.Email == model.Email))
                {
                    return BadRequest("Username is already taken");
                }
                else
                {
                    var user = new User
                    {
                        Email = model.Email,
                        Name = model.Name,
                        Password = HashPassword(model.Password),
                        HasPremium = false,
                        FirebaseId = model.FirebaseId,
                    };

                    _appDbContext.Users.Add(user);
                    await _appDbContext.SaveChangesAsync();
                    return Ok(new { id = user.Id });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginModel model)
        {
            var user = _appDbContext.Users.FirstOrDefault(u => u.Email == model.Email);

            if (user == null)
            {
                return BadRequest("Invalid username or password");
            }

            if (VerifyPassword(model.Password, user.Password))
            {
                return Ok(new { id = user.Id });
            }

            return BadRequest("Invalid username or password");
        }

        [HttpGet("get_user_by_id/{userId}")]
        public async Task<IActionResult> GetUserById(int userId)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);

                if (user == null)
                {
                    return NotFound("User not found.");
                }

                var updatedUser = new UpdateUser
                {
                    Email = user.Email,
                    Name = user.Name,
                    HasPremium = user.HasPremium,
                };

                return Ok(updatedUser);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpDelete("delete_user/{userId}")]
        public async Task<IActionResult> DeleteReservation(int userId)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);

                if (user == null)
                {
                    return NotFound("User not found.");
                }

                _appDbContext.Users.Remove(user);
                await _appDbContext.SaveChangesAsync();

                return Ok($"User {user.Id} deleted.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPost("assign-house/{userId}/{houseId}")]
        public async Task<IActionResult> AssignHouseToUser(int userId, int houseId)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);
                House house = _appDbContext.Houses.FirstOrDefault(h => h.Id == houseId);

                if (user == null || house == null)
                {
                    return NotFound("User or house not found.");
                }

                int usersWithHouseCount = _appDbContext.Users.Count(u => u.House != null && u.House.Id == houseId);

                if (usersWithHouseCount >= house.HouseSize)
                {
                    return BadRequest("House has reached its maximum capacity.");
                }

                user.House = house;
                _appDbContext.Users.Update(user);
                await _appDbContext.SaveChangesAsync();

                return Ok($"Assigned house {house.Id} to user {user.Id}");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPost("remove-house/{userId}")]
        public async Task<IActionResult> RemoveHouseFromUser(int userId)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);

                if (user == null)
                {
                    return NotFound("User not found.");
                }

                user.House = null;
                _appDbContext.Users.Update(user);
                await _appDbContext.SaveChangesAsync();

                return Ok($"Removed house from user {user.Id}");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPut("edit-user/{userId}")]
        public async Task<IActionResult> EditUserData(int userId, UpdateUser editedUser)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);

                if (user == null)
                {
                    return NotFound("User not found.");
                }

                user.Name = editedUser.Name;
                user.Email = editedUser.Email;
                user.HasPremium = editedUser.HasPremium;

                _appDbContext.Users.Update(user);
                await _appDbContext.SaveChangesAsync();

                return Ok($"User {user.Id} data updated.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPost("create-reservation/{userId}/{itemId}")]
        public async Task<IActionResult> CreateReservation(int userId, int itemId, ReservationRequest reservationRequest)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);
                Item item = _appDbContext.Items.FirstOrDefault(u => u.Id == itemId);

                if (user == null || item == null)
                {
                    return NotFound("User or item not found.");
                }

                var reservation = new Reservation
                {
                    User = user,
                    StartTime = reservationRequest.StartTime,
                    EndTime = reservationRequest.EndTime
                };

                _appDbContext.Reservations.Add(reservation);
                await _appDbContext.SaveChangesAsync();
                item.Reservations.Add(reservation);
                await _appDbContext.SaveChangesAsync();
                return Ok($"Reservation {reservation.Id} created for user {user.Id}");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }


        [HttpDelete("delete-reservation/{userId}/{reservationId}")]
        public async Task<IActionResult> DeleteReservation(int userId, int reservationId)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);
                Reservation reservation = _appDbContext.Reservations.FirstOrDefault(r => r.Id == reservationId);

                if (user == null || reservation == null)
                {
                    return NotFound("User or reservation not found.");
                }

                if (reservation.User.Id != userId)
                {
                    return BadRequest("User does not own this reservation.");
                }

                _appDbContext.Reservations.Remove(reservation);
                await _appDbContext.SaveChangesAsync();

                return Ok($"Reservation {reservation.Id} deleted for user {user.Id}");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPut("update-reservation/{userId}/{reservationId}")]
        public async Task<IActionResult> UpdateReservation(int userId, int reservationId, ReservationRequest updatedReservation)
        {
            try
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);
                Reservation reservation = _appDbContext.Reservations.FirstOrDefault(r => r.Id == reservationId);

                if (user == null || reservation == null)
                {
                    return NotFound("User or reservation not found.");
                }

                if (reservation.User.Id != userId)
                {
                    return BadRequest("User does not own this reservation.");
                }

                reservation.StartTime = updatedReservation.StartTime;
                reservation.EndTime = updatedReservation.EndTime;

                _appDbContext.Reservations.Update(reservation);
                await _appDbContext.SaveChangesAsync();

                return Ok($"Reservation {reservation.Id} updated for user {user.Id}");
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }

        [HttpPost("sendMessage/{userId}")]
        public async Task<IActionResult> SendMessage(int userId, String messageString)
        {
            try
            {
                return Ok(messageString);
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);

                if (user == null)
                {
                    return NotFound("User not found.");
                }

                var message = new Message()
                {
                    Notification = new Notification
                    {
                        Title = "HoPla Notification",
                        Body = messageString
                    },
                    Token = user.FirebaseId,
                };

                // Send a message to the device corresponding to the provided
                // registration token.
                string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                // Response is a message ID string.
                Console.WriteLine("Successfully sent message: " + response);

                
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.InnerException.Message);
            }
        }
    }
}
