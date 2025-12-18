// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item affix "><a href="index.html">Home</a></li><li class="chapter-item "><a href="cloud/what_is_cloud_computing.html"><strong aria-hidden="true">1.</strong> What is Cloud Computing?</a></li><li class="chapter-item "><a href="cloud/index.html"><strong aria-hidden="true">2.</strong> Cloud Computing Providers</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="cloud/aws.html"><strong aria-hidden="true">2.1.</strong> Amazon Web Services (AWS)</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="cloud/aws/networking.html"><strong aria-hidden="true">2.1.1.</strong> Networking</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="cloud/aws/vpc_policy.html"><strong aria-hidden="true">2.1.1.1.</strong> VPC Policy</a></li><li class="chapter-item "><a href="cloud/aws/migration.html"><strong aria-hidden="true">2.1.1.2.</strong> Migration</a></li></ol></li></ol></li></ol></li><li class="chapter-item "><a href="kion/kion.html"><strong aria-hidden="true">3.</strong> Cloud Management</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="kion/features/getting_started.html"><strong aria-hidden="true">3.1.</strong> Getting Started</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="kion/features/access_roles.html"><strong aria-hidden="true">3.1.1.</strong> Access</a></li><li class="chapter-item "><a href="kion/features/finances.html"><strong aria-hidden="true">3.1.2.</strong> Budgets &amp; Finances</a></li><li class="chapter-item "><a href="kion/features/cloud_management.html"><strong aria-hidden="true">3.1.3.</strong> Cloud Management</a></li><li class="chapter-item "><a href="kion/features/key_features.html"><strong aria-hidden="true">3.1.4.</strong> Compliance</a></li><li class="chapter-item "><a href="kion/features/troubleshooting_and_support.html"><strong aria-hidden="true">3.1.5.</strong> Troubleshooting and Support</a></li><li class="chapter-item "><a href="kion/features/cli.html"><strong aria-hidden="true">3.1.6.</strong> CLI</a></li></ol></li></ol></li><li class="chapter-item "><a href="cps/email_auth.html"><strong aria-hidden="true">4.</strong> Email Authentication</a></li><li class="chapter-item "><a href="github/index.html"><strong aria-hidden="true">5.</strong> GitHub</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="github/guidelines.html"><strong aria-hidden="true">5.1.</strong> Guidelines</a></li><li class="chapter-item "><a href="github/organizations.html"><strong aria-hidden="true">5.2.</strong> Organizations</a></li><li class="chapter-item "><a href="github/teams.html"><strong aria-hidden="true">5.3.</strong> Teams</a></li><li class="chapter-item "><a href="github/advanced_features.html"><strong aria-hidden="true">5.4.</strong> Advanced Features</a></li><li class="chapter-item "><a href="github/faqs.html"><strong aria-hidden="true">5.5.</strong> FAQs</a></li><li class="chapter-item "><a href="github/migrating.html"><strong aria-hidden="true">5.6.</strong> Migrating to Cloud</a></li><li class="chapter-item "><a href="github/migration_tool.html"><strong aria-hidden="true">5.7.</strong> TAMU Migration Tool</a></li></ol></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0].split("?")[0];
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
