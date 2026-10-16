namespace RaceDay.API.Models
{
    public class Category
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty; // e.g., "5K Run", "10K Cycling"
        public string Description { get; set; } = string.Empty;

        public int EventId { get; set; }
        public Event? Event { get; set; }

        public ICollection<Enrolment> Enrolments { get; set; } = new List<Enrolment>();
    }
}