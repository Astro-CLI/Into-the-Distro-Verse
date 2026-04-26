// ---------------------------------------------------------
// FULL WIKI LOGIC - JAVASCRIPT
// ---------------------------------------------------------

/*
   COPY BUTTON LOGIC:
   This loop finds every <pre> block (terminal window) and 
   adds a "Copy" button to it.
*/
const codeBlocks = Array.from(document.querySelectorAll('pre'));

for (const block of codeBlocks) {
const button = document.createElement('button');
button.type = 'button';
button.className = 'copy-button';
button.textContent = 'Copy';
button.setAttribute('aria-label', 'Copy code block');
block.style.position = 'relative';
block.appendChild(button);

button.addEventListener('click', async (event) => {
event.preventDefault();
event.stopPropagation();

const code = block.querySelector('code');
const text = code ? code.innerText : block.textContent;

try {
if (navigator.clipboard && window.isSecureContext) {
await navigator.clipboard.writeText(text.trimEnd());
} else {
const textarea = document.createElement('textarea');
textarea.value = text.trimEnd();
textarea.style.position = 'fixed';
textarea.style.opacity = '0';
document.body.appendChild(textarea);
textarea.focus();
textarea.select();
document.execCommand('copy');
textarea.remove();
}

// Show feedback
block.setAttribute('data-copied', 'true');
button.textContent = 'Copied!';
button.style.background = '#1a3a1a';
button.style.borderColor = '#4ade80';
button.style.color = '#4ade80';

setTimeout(() => {
block.removeAttribute('data-copied');
button.textContent = 'Copy';
button.style.background = '';
button.style.borderColor = '';
button.style.color = '';
}, 1500);
} catch (err) {
console.error('Copy failed!', err);
button.textContent = 'Failed';
setTimeout(() => {
button.textContent = 'Copy';
}, 1500);
}
});
}

/*
   MARKDOWN VIEWER:
   The original Markdown text is hidden in a <script id="md-content"> tag.
   This code pulls that text and shows it in a pop-up modal.
*/
function getMdContent() {
const script = document.getElementById('md-content');
return script ? script.textContent : null;
}

function initMarkdownViewer() {
const mdContent = getMdContent();
if (!mdContent) return;

const viewerBtn = document.createElement('button');
viewerBtn.className = 'markdown-viewer-btn';
viewerBtn.textContent = 'View Markdown Source';
viewerBtn.setAttribute('aria-label', 'View markdown source');

const article = document.querySelector('.wiki-article');
if (article && article.firstChild) {
article.insertBefore(viewerBtn, article.firstChild);
}

viewerBtn.addEventListener('click', () => showMarkdownModal(mdContent));
}

function showMarkdownModal(mdContent) {
const oldModal = document.getElementById('md-viewer-modal');
if (oldModal) oldModal.remove();

const modal = document.createElement('div');
modal.id = 'md-viewer-modal';
modal.className = 'md-viewer-modal';

modal.innerHTML = `
<div>
<div class="md-viewer-header">
<h2>Original Markdown Source</h2>
<button class="md-viewer-close">✕</button>
</div>
<pre class="md-viewer-content">${mdContent}</pre>
</div>
`;

document.body.appendChild(modal);

modal.querySelector('.md-viewer-close').onclick = () => modal.remove();
modal.onclick = (e) => { if (e.target === modal) modal.remove(); };

const escHandler = (e) => {
if (e.key === 'Escape') {
modal.remove();
document.removeEventListener('keydown', escHandler);
}
};
document.addEventListener('keydown', escHandler);
}

document.addEventListener('DOMContentLoaded', initMarkdownViewer);
