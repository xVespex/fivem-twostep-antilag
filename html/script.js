const sounds = {
    "twostep_custom.ogg": new Audio("sounds/twostep_custom.ogg"),
    "backfire_custom.ogg": new Audio("sounds/backfire_custom.ogg"),
    "turboflutter_custom.ogg": new Audio("sounds/turboflutter_custom.ogg"),
};

// Preload sounds
for (let sound in sounds) {
    sounds[sound].load();
}

window.addEventListener('message', (event) => {
    if (event.data.action === 'playSound') {
        const soundName = event.data.sound;
        if (sounds[soundName]) {
            sounds[soundName].currentTime = 0;
            sounds[soundName].volume = 0.7;
            sounds[soundName].play();
        }
    }
});
