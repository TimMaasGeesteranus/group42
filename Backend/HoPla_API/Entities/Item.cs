﻿using System.ComponentModel.DataAnnotations;

namespace HoPla_API.Entities
{
    public class Item
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string? Name { get; set; }

        public ICollection<Reservation>? Reservations { get; set; }

        public string? Image { get; set; }

        public string? Qrcode { get; set; }

        public Item(string name, string image, string qrcode)
        {
            Name = name;
            Image = image;
            Qrcode = qrcode;
            Reservations = new List<Reservation>();
        }
    }

    public class ItemInputModel
    {
        [MaxLength(50)]
        public string Name { get; set; }

        public int HouseId { get; set; }

        public string? Image { get; set; }

        public string? Qrcode { get; set; }
    }
}
