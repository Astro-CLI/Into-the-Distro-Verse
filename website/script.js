const navSearchForm = document.getElementById('nav-search');
const navSearchInput = document.getElementById('nav-search-input');

const sectionSearchMap = [
	{ terms: ['home', 'intro', 'main'], id: 'intro' },
	{ terms: ['documentation', 'docs', 'index', 'arch', 'fedora', 'debian'], id: 'docs-index' },
	{ terms: ['software', 'repositories', 'packages', 'restoration'], id: 'software' },
	{ terms: ['hardening', 'security', 'integrity', 'firewall', 'clamav'], id: 'hardening' },
	{ terms: ['environment', 'kde', 'grub', 'configuration'], id: 'environment' },
	{ terms: ['all guides', 'all pages', 'html', 'converted'], id: 'all-pages' },
	{ terms: ['resources', 'resource', 'community', 'tools', 'youtube'], id: 'resources' }
];

if (navSearchForm && navSearchInput) {
	navSearchForm.addEventListener('submit', (event) => {
		event.preventDefault();
		const query = navSearchInput.value.trim().toLowerCase();

		if (!query) {
			return;
		}

		const match = sectionSearchMap.find((entry) => entry.terms.some((term) => query.includes(term)));
		const targetId = match ? match.id : 'intro';
		const targetElement = document.getElementById(targetId);

		if (targetElement) {
			targetElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
			window.history.replaceState(null, '', `#${targetId}`);
		}
	});
}

const codeBlocks = Array.from(document.querySelectorAll('pre'));

for (const block of codeBlocks) {
	const button = document.createElement('button');
	button.type = 'button';
	button.className = 'copy-button';
	button.textContent = 'Copy';
	button.setAttribute('aria-label', 'Copy code block');
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

			block.dataset.copied = 'true';
			button.textContent = 'Copied';
			window.clearTimeout(block._copyTimer);
			block._copyTimer = window.setTimeout(() => {
				delete block.dataset.copied;
				button.textContent = 'Copy';
			}, 1200);
		} catch {
			block.dataset.copied = 'error';
			button.textContent = 'Error';
			window.clearTimeout(block._copyTimer);
			block._copyTimer = window.setTimeout(() => {
				delete block.dataset.copied;
				button.textContent = 'Copy';
			}, 1200);
		}
	});
}

// Markdown viewer functionality
function getMdFileName() {
	const path = window.location.pathname;
	const filename = path.split('/').pop();
	
	if (filename === 'index.html' || filename === 'history.html' || filename === 'README.html') {
		return null;
	}
	
	// Convert HTML filename to markdown filename
	if (filename.startsWith('distroverse--docs--')) {
		return filename.replace('distroverse--docs--', '').replace('.html', '.md');
	} else if (filename.startsWith('distroverse--configs--')) {
		return '../docs/' + filename.replace('distroverse--configs--', '').replace('.html', '.md');
	} else if (filename === 'apache-tor-docker.html') {
		return 'apache-tor-docker.md';
	}
	
	return null;
}

function initMarkdownViewer() {
	const mdFile = getMdFileName();
	if (!mdFile) return;

	const viewerBtn = document.createElement('button');
	viewerBtn.className = 'markdown-viewer-btn';
	viewerBtn.textContent = 'View Markdown';
	viewerBtn.setAttribute('aria-label', 'View markdown source');
	
	const article = document.querySelector('.wiki-article');
	if (article && article.firstChild) {
		article.insertBefore(viewerBtn, article.firstChild);
	}

	viewerBtn.addEventListener('click', async () => {
		await showMarkdownModal(mdFile);
	});
}

async function showMarkdownModal(mdPath) {
	let existingModal = document.getElementById('md-viewer-modal');
	if (existingModal) {
		existingModal.remove();
	}

	try {
		const response = await fetch(mdPath);
		if (!response.ok) throw new Error('Failed to load markdown');
		
		const mdContent = await response.text();
		
		const modal = document.createElement('div');
		modal.id = 'md-viewer-modal';
		modal.className = 'md-viewer-modal';
		
		const closeBtn = document.createElement('button');
		closeBtn.className = 'md-viewer-close';
		closeBtn.textContent = '✕';
		closeBtn.addEventListener('click', () => modal.remove());
		
		const content = document.createElement('pre');
		content.className = 'md-viewer-content';
		content.textContent = mdContent;
		
		const header = document.createElement('div');
		header.className = 'md-viewer-header';
		header.innerHTML = '<h2>Markdown Source</h2>';
		header.appendChild(closeBtn);
		
		modal.appendChild(header);
		modal.appendChild(content);
		document.body.appendChild(modal);
		
		// Close on escape key
		const escHandler = (e) => {
			if (e.key === 'Escape') {
				modal.remove();
				document.removeEventListener('keydown', escHandler);
			}
		};
		document.addEventListener('keydown', escHandler);
		
		// Close on background click
		modal.addEventListener('click', (e) => {
			if (e.target === modal) {
				modal.remove();
				document.removeEventListener('keydown', escHandler);
			}
		});
	} catch (error) {
		console.error('Error loading markdown:', error);
		alert('Failed to load markdown file');
	}
}

document.addEventListener('DOMContentLoaded', initMarkdownViewer);
