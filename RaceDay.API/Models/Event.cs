namespace RaceDay.API.Models
{
    public class Event
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public DateTime EventDate { get; set; }

        public ICollection<Category> Categories { get; set; } = new List<Category>();
        public ICollection<Enrolment> Enrolments { get; set; } = new List<Enrolment>();
    }
}