using System.ComponentModel.DataAnnotations;

namespace HoPla_API.Entities
{
    public class Reservation
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public User? User { get; set; }

        [Required]
        public Item? Item { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public DateTime EndTime { get; set; }
    }

    public class ReservationRequest
    {
        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }
    }
}
