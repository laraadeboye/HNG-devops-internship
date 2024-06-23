document.addEventListener('DOMContentLoaded', function() {
    console.log('Website loaded successfully.');

    const colorButton = document.getElementById('colorButton');
    const deployMessage = document.querySelector('.deploy-message');

    // Change background color on button click
    colorButton.addEventListener('click', function() {
        const colors = ['#ffeb3b', '#8bc34a', '#00bcd4', '#e91e63', '#3f51b5'];
        const randomColor = colors[Math.floor(Math.random() * colors.length)];
        document.body.style.backgroundColor = randomColor;
    });

    // Add interactive animation to the deploy message
    deployMessage.addEventListener('mouseover', function() {
        deployMessage.style.animation = 'none';
        setTimeout(() => {
            deployMessage.style.animation = '';
        }, 10);
    });
});