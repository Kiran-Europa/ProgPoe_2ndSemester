using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDay.API.Data;
using RaceDay.API.Models;

namespace RaceDay.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventsController : ControllerBase
    {
        private readonly RaceDayDbContext _context;

        public EventsController(RaceDayDbContext context)
        {
            _context = context;
        }

        // GET: api/events
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Event>>> GetEvents()
        {
            return await _context.Events
                .Include(e => e.Categories)
                .ToListAsync();
        }

        // GET: api/events/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Event>> GetEvent(int id)
        {
            var raceEvent = await _context.Events
                .Include(e => e.Categories)
                .FirstOrDefaultAsync(e => e.Id == id);

            if (raceEvent == null)
            {
                return NotFound();
            }

            return raceEvent;
        }

        // POST: api/events
        [HttpPost]
        public async Task<ActionResult<Event>> PostEvent(Event raceEvent)
        {
            _context.Events.Add(raceEvent);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEvent), new { id = raceEvent.Id }, raceEvent);
        }

        // DELETE: api/events/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {
            var raceEvent = await _context.Events.FindAsync(id);
            if (raceEvent == null)
            {
                return NotFound();
            }

            _context.Events.Remove(raceEvent);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}