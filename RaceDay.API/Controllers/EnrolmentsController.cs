using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RaceDay.API.Data;
using RaceDay.API.Models;

namespace RaceDay.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EnrolmentsController : ControllerBase
    {
        private readonly RaceDayDbContext _context;

        public EnrolmentsController(RaceDayDbContext context)
        {
            _context = context;
        }

        // GET: api/enrolments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Enrolment>>> GetEnrolments()
        {
            return await _context.Enrolments
                .Include(e => e.User)
                .Include(e => e.Event)
                .Include(e => e.Category)
                .ToListAsync();
        }

        // POST: api/enrolments
        [HttpPost]
        public async Task<ActionResult<Enrolment>> PostEnrolment(Enrolment enrolment)
        {
            enrolment.EnrolmentDate = DateTime.UtcNow;
            _context.Enrolments.Add(enrolment);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEnrolments), new { id = enrolment.Id }, enrolment);
        }

        // DELETE: api/enrolments/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEnrolment(int id)
        {
            var enrolment = await _context.Enrolments.FindAsync(id);
            if (enrolment == null)
            {
                return NotFound();
            }

            _context.Enrolments.Remove(enrolment);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}