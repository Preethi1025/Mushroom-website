// Initialize AOS for animation
AOS.init();

// Card observer animation
const cards = document.querySelectorAll('.card');

const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('show');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.3 });

cards.forEach(card => {
  observer.observe(card);
});
