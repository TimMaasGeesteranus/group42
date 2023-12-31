﻿using HoPla_API.Context;
using HoPla_API.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HoPla_API.Controllers
{
    [ApiController]
    [Route("house")]
    public class HouseController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;

        public HouseController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpGet("{id}")]
        public IActionResult GetHouseById(string id)
        {
            if (int.TryParse(id, out var houseId))
            {
                try
                {
                    House house = _appDbContext.Houses.Include(h => h.Items).Single(x => x.Id == houseId);
                    return Ok(house);
                }
                catch 
                {
                    return NotFound("No house found!");
                }
            }
            return BadRequest("Input must be int!");
        }

        [HttpPost("{userId}")]
        public IActionResult CreateHouse(int userId, [FromBody] HouseInputModel houseInput)
        {
            if (ModelState.IsValid)
            {
                User user = _appDbContext.Users.FirstOrDefault(u => u.Id == userId);

                House newHouse = new House(houseInput.Name, houseInput.HasPremium)
                {
                    HouseSize = 15,
                };

                user.House = newHouse;
                _appDbContext.Users.Update(user);
                _appDbContext.Houses.Add(newHouse);
                _appDbContext.SaveChanges();

                return CreatedAtAction(nameof(GetHouseById), new { id = newHouse.Id }, newHouse);
            }

            return BadRequest(ModelState);
        }

        [HttpPut("{id}")]
        public IActionResult UpdateHouse(string id, [FromBody] HouseInputModel houseInput)
        {
            if (int.TryParse(id, out var houseId))
            {
                try
                {
                    House existingHouse = _appDbContext.Houses.Single(x => x.Id == houseId);

                    if(houseInput.Name != null)
                        existingHouse.Name = houseInput.Name;

                    if(houseInput.HasPremium != existingHouse.HasPremium)
                        existingHouse.HasPremium = houseInput.HasPremium;
                    
                    if(houseInput.HouseSize != null)
                        existingHouse.HouseSize = houseInput.HouseSize;

                    if (houseInput.HasPremium == true)
                        existingHouse.HouseSize = 30;

                    _appDbContext.SaveChanges();

                    return Ok(existingHouse);
                }
                catch (InvalidOperationException)
                {
                    return NotFound("No house found!");
                }
            }
            return BadRequest("Input must be int!");
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteHouse(string id)
        {
            if (int.TryParse(id, out var houseId))
            {
                House houseToRemove = _appDbContext.Houses.SingleOrDefault(x => x.Id == houseId);

                if (houseToRemove != null)
                {
                    _appDbContext.Houses.Remove(houseToRemove);
                    _appDbContext.SaveChanges();

                    return NoContent();
                }
                else
                {
                    return NotFound("No house found!");
                }
            }

            return BadRequest("Input must be int!");
        }

        [HttpGet("{id}/users")]
        public IActionResult GetHouseUsers(string id)
        {
            if (int.TryParse(id, out var houseId))
            {
                var users = _appDbContext.Users
                .Where(u => u.House != null && u.House.Id == houseId)
                .Select(u => new UpdateUser
                {
                    Email = u.Email,
                    Name = u.Name,
                    HasPremium = u.HasPremium
                })
                .ToList();

                if (users == null)
                {
                    return NotFound("House not found");
                }

                return Ok(users);
            }
            return BadRequest("Input must be int!");
        }
    }
}
