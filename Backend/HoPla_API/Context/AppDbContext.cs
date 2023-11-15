using HoPla_API.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using static System.Net.Mime.MediaTypeNames;

namespace HoPla_API.Context
{
    public class AppDbContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<House> Houses { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<Item> Items { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
            Seed();
            Database.EnsureCreated();
        }

        public void Seed()
        {

            House h1 = new("MyHouse", false);   
            House h2 = new("MyOtherHouse", false);


            User u1 = new("mail@mail.com", "User1", "secret", false, h1);

            Houses.Add(h1);
            Houses.Add(h2);
            Users.Add(u1);


            SaveChanges();
        }
    }
}
