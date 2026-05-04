(function () {
    function initSidebar() {
        var toggle = document.getElementById("navToggle");
        var sidebar = document.getElementById("appSidebar");

        if (!toggle || !sidebar) {
            return;
        }

        function openSidebar() {
            document.body.classList.add("sidebar-open");
            toggle.setAttribute("aria-expanded", "true");
            
            // GSAP animation for sidebar opening
            gsap.fromTo(sidebar,
                { x: -sidebar.offsetWidth },
                {
                    x: 0,
                    duration: 0.4,
                    ease: "power2.out",
                    onStart: function() {
                        sidebar.style.transform = "translateX(0)";
                    }
                }
            );
            
            // Animate nav toggle button
            gsap.to(toggle, {
                rotation: 90,
                duration: 0.3,
                ease: "power2.out"
            });
        }

        function closeSidebar() {
            document.body.classList.remove("sidebar-open");
            toggle.setAttribute("aria-expanded", "false");
            
            // GSAP animation for sidebar closing
            gsap.to(sidebar, {
                x: -sidebar.offsetWidth,
                duration: 0.4,
                ease: "power2.out",
                onComplete: function() {
                    sidebar.style.transform = "translateX(-100%)";
                }
            });
            
            // Animate nav toggle button back
            gsap.to(toggle, {
                rotation: 0,
                duration: 0.3,
                ease: "power2.out"
            });
        }

        toggle.addEventListener("click", function () {
            if (document.body.classList.contains("sidebar-open")) {
                closeSidebar();
                return;
            }
            openSidebar();
        });

        document.querySelectorAll("[data-sidebar-close]").forEach(function (node) {
            node.addEventListener("click", closeSidebar);
        });

        document.querySelectorAll(".sidebar .nav-item, .sidebar .logout-btn").forEach(function (node) {
            node.addEventListener("click", function () {
                if (window.innerWidth < 768) {
                    closeSidebar();
                }
            });
        });

        window.addEventListener("resize", function () {
            if (window.innerWidth >= 768) {
                closeSidebar();
            }
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && document.body.classList.contains("sidebar-open")) {
                closeSidebar();
            }
        });
    }

    function initToasts() {
        var stack = document.getElementById("toastStack");
        if (!stack) {
            return;
        }

        window.showToast = function (message, type) {
            var toastType = type || "success";
            var icon = toastType === "success" ? "&#10003;" : toastType === "error" ? "&#10005;" : toastType === "warning" ? "!" : "i";
            var title = toastType === "success" ? "Succes" : toastType === "error" ? "Erreur" : toastType === "warning" ? "Avertissement" : "Information";

            while (stack.children.length >= 3) {
                stack.removeChild(stack.lastElementChild);
            }

            var toast = document.createElement("div");
            toast.className = "toast toast-" + toastType;
            toast.innerHTML =
                "<div class=\"toast-icon\">" + icon + "</div>"
                + "<div class=\"toast-body\">"
                + "<strong class=\"toast-title\">" + title + "</strong>"
                + "<div class=\"toast-message\"></div>"
                + "<div class=\"toast-progress\"></div>"
                + "</div>"
                + "<button type=\"button\" class=\"toast-close\" aria-label=\"Fermer\">&times;</button>";

            toast.querySelector(".toast-message").textContent = message;
            stack.prepend(toast);

            var removeToast = function () {
                if (!toast.parentNode) {
                    return;
                }
                toast.classList.add("toast-out");
                window.setTimeout(function () {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 220);
            };

            var timeoutId = window.setTimeout(removeToast, 30000);
            toast.querySelector(".toast-close").addEventListener("click", function () {
                window.clearTimeout(timeoutId);
                removeToast();
            });
        };

        document.querySelectorAll(".toast-bootstrap").forEach(function (node) {
            var message = node.getAttribute("data-toast-message");
            var type = node.getAttribute("data-toast-type") || "success";
            if (message) {
                window.showToast(message, type);
            }
            node.remove();
        });
    }

    function initConfirmModal() {
        var modal = document.getElementById("confirmModal");
        var dialog = modal ? modal.querySelector(".confirm-dialog") : null;
        var titleNode = document.getElementById("confirmTitle");
        var messageNode = document.getElementById("confirmMessage");
        var badgeNode = document.getElementById("confirmBadge");
        var cancelButton = document.getElementById("confirmCancel");
        var acceptButton = document.getElementById("confirmAccept");

        if (!modal || !dialog || !titleNode || !messageNode || !cancelButton || !acceptButton || !badgeNode) {
            return;
        }

        var pendingAction = null;
        var lastFocusedElement = null;

        function setVariant(variant) {
            modal.setAttribute("data-variant", variant);
            acceptButton.className = variant === "danger" ? "btn btn-danger" : "btn btn-primary";
            badgeNode.textContent = variant === "danger" ? "!" : "?";
        }

        function openModal(options, onConfirm) {
            pendingAction = onConfirm;
            lastFocusedElement = document.activeElement;

            titleNode.textContent = options.title || "Confirmer l action";
            messageNode.textContent = options.message || "Voulez-vous continuer ?";
            cancelButton.textContent = options.cancelLabel || "Annuler";
            acceptButton.textContent = options.confirmLabel || "Confirmer";
            setVariant(options.variant || "neutral");

            modal.removeAttribute("hidden");
            document.body.classList.add("modal-open");
            acceptButton.focus();
        }

        function closeModal() {
            modal.setAttribute("hidden", "hidden");
            document.body.classList.remove("modal-open");
            pendingAction = null;

            if (lastFocusedElement && typeof lastFocusedElement.focus === "function") {
                lastFocusedElement.focus();
            }
        }

        function extractOptions(element) {
            return {
                title: element.getAttribute("data-confirm-title"),
                message: element.getAttribute("data-confirm"),
                confirmLabel: element.getAttribute("data-confirm-confirm-label"),
                cancelLabel: element.getAttribute("data-confirm-cancel-label"),
                variant: element.getAttribute("data-confirm-variant")
            };
        }

        document.querySelectorAll("[data-confirm]").forEach(function (element) {
            var options = extractOptions(element);

            if (element.tagName === "FORM") {
                element.addEventListener("submit", function (event) {
                    event.preventDefault();
                    openModal(options, function () {
                        HTMLFormElement.prototype.submit.call(element);
                    });
                });
                return;
            }

            element.addEventListener("click", function (event) {
                event.preventDefault();
                openModal(options, function () {
                    window.location.assign(element.href);
                });
            });
        });

        acceptButton.addEventListener("click", function () {
            var action = pendingAction;
            closeModal();
            if (typeof action === "function") {
                action();
            }
        });

        cancelButton.addEventListener("click", function (event) {
            event.preventDefault();
            closeModal();
        });

        modal.addEventListener("click", function (event) {
            if (event.target.hasAttribute("data-confirm-close")) {
                closeModal();
            }
        });

        dialog.addEventListener("click", function (event) {
            event.stopPropagation();
        });

        document.addEventListener("keydown", function (event) {
            if (modal.hasAttribute("hidden")) {
                return;
            }

            if (event.key === "Escape") {
                closeModal();
            }
        });
    }

    function init() {
        initSidebar();
        initToasts();
        initConfirmModal();
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
