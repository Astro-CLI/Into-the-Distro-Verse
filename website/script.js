/**
 * Into-the-Distro-Verse Script
 * Handles Copy buttons for Code Blocks
 */

document.addEventListener('DOMContentLoaded', () => {
    initCopyButtons();
});

/**
 * Adds a 'Copy' button to every <pre> code block
 */
function initCopyButtons() {
    const codeBlocks = document.querySelectorAll('pre, .sourceCode');
    
    codeBlocks.forEach((block) => {
        // Create the button
        const button = document.createElement('button');
        button.className = 'copy-button';
        button.textContent = 'Copy';
        button.type = 'button';
        button.setAttribute('aria-label', 'Copy code to clipboard');
        
        block.appendChild(button);
        
        button.addEventListener('click', async (e) => {
            e.preventDefault();
            e.stopPropagation();
            const code = block.querySelector('code');
            const text = code ? code.innerText : block.innerText;
            
            try {
                // Remove the 'Copy' text from the clipboard if it accidentally got included
                const cleanText = text.replace(/Copy$/, '').trim();
                await navigator.clipboard.writeText(cleanText);
                button.textContent = 'Copied!';
                button.style.color = '#00ffff';
                
                setTimeout(() => {
                    button.textContent = 'Copy';
                    button.style.color = '';
                }, 2000);
            } catch (err) {
                console.error('Failed to copy!', err);
                button.textContent = 'Error';
            }
        });
    });
}
