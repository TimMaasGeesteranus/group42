using HoPla_API.Context;
using HoPla_API.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;

namespace HoPla_API.Controllers
{
    [ApiController]
    [Route("items")]
    public class ItemController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;

        public ItemController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpGet("get_item_by_id/{id}")]
        public IActionResult GetItemById(string id)
        {
            if (int.TryParse(id, out var itemId))
            {
                try
                {
                    Item item = _appDbContext.Items.Single(x => x.Id == itemId);
                    return Ok(item);
                }
                catch
                {
                    return NotFound("No item found");
                }
            }
            return BadRequest("Input must be int");
        }

        [HttpGet("get_items_by_house_id/{id}")]
        public IActionResult GetItemByHouseId(string id)
        {
            if (int.TryParse(id, out var houseId))
            {
                try
                {
                    var house = _appDbContext.Houses.Include(h => h.Items).FirstOrDefault(h => h.Id == houseId);

                    if (house == null)
                    {
                        return NotFound();
                    }

                    var items = house.Items;

                    return Ok(items);
                }
                catch
                {
                    return NotFound("No item found");
                }
            }
            return BadRequest("Input must be int");
        }

        [HttpPost("create_item")]
        public IActionResult CreateItem([FromBody] ItemInputModel itemInput)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    House associatedHouse = _appDbContext.Houses.Single(h => h.Id == itemInput.HouseId);

                    Item newItem = new Item
                    {
                        Name = itemInput.Name,
                        Image = itemInput.Image,
                        Qrcode = itemInput.Qrcode,
                    };

                    _appDbContext.Items.Add(newItem);
                    _appDbContext.SaveChanges();

                    associatedHouse.Items.Add(newItem);
                    _appDbContext.SaveChanges();
                    return CreatedAtAction(nameof(GetItemById), new { id = newItem.Id }, newItem);
                }
                catch (InvalidOperationException)
                {
                    return NotFound("Associated house not found");
                }
            }

            return BadRequest(ModelState);
        }

        [HttpPut("update_item/{id}")]
        public IActionResult UpdateItem(string id, [FromBody] ItemInputModel itemInput)
        {
            if (int.TryParse(id, out var itemId))
            {
                try
                {
                    Item existingItem = _appDbContext.Items.Single(x => x.Id == itemId);

                    existingItem.Name = itemInput.Name;
                    existingItem.Image = itemInput.Image;
                    existingItem.Qrcode = itemInput.Qrcode;

                    _appDbContext.SaveChanges();

                    return Ok(existingItem);
                }
                catch (InvalidOperationException)
                {
                    return NotFound("No item found");
                }
            }
            return BadRequest("Input must be int");
        }

        [HttpDelete("delete_item/{id}")]
        public IActionResult DeleteItem(string id)
        {
            if (int.TryParse(id, out var itemId))
            {
                Item itemToRemove = _appDbContext.Items.SingleOrDefault(x => x.Id == itemId);

                if (itemToRemove != null)
                {
                    _appDbContext.Items.Remove(itemToRemove);
                    _appDbContext.SaveChanges();

                    return NoContent();
                }
                else
                {
                    return NotFound("No item found");
                }
            }

            return BadRequest("Input must be int");
        }
    }
}
