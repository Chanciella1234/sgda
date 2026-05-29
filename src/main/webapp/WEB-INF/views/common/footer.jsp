<%@ taglib uri="jakarta.tags.core" prefix="c" %>
                <footer class="app-footer">
                    <span>SGDA &copy; 2026 &mdash; Universit&eacute; Polytechnique de Gitega</span>
                    <span>D&eacute;partement G&eacute;nie Logiciel / BAC3</span>
                </footer>
            </div><!-- /.main-inner -->
        </div><!-- /.main -->
    </div><!-- /.layout -->
</div><!-- /.app-shell -->

<div id="toastStack" class="toast-stack" aria-live="polite" aria-atomic="true"></div>

<c:if test="${not empty flashMessage}">
    <div class="toast-bootstrap" hidden
         data-toast-message="${flashMessage}"
         data-toast-type="${flashType == 'success' ? 'success' : (flashType == 'warning' ? 'warning' : 'error')}"></div>
</c:if>
<c:if test="${not empty param.success}">
    <div class="toast-bootstrap" hidden data-toast-message="${param.success}" data-toast-type="success"></div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="toast-bootstrap" hidden data-toast-message="${param.error}" data-toast-type="error"></div>
</c:if>
<c:if test="${not empty param.warning}">
    <div class="toast-bootstrap" hidden data-toast-message="${param.warning}" data-toast-type="warning"></div>
</c:if>
<c:if test="${not empty param.info}">
    <div class="toast-bootstrap" hidden data-toast-message="${param.info}" data-toast-type="info"></div>
</c:if>

<div id="confirmModal" class="confirm-layer" hidden>
    <div class="confirm-backdrop" data-confirm-close></div>
    <div class="confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="confirmTitle" aria-describedby="confirmMessage">
        <div class="confirm-dialog-accent"></div>
        <div class="confirm-dialog-body">
            <div class="confirm-badge" id="confirmBadge">!</div>
            <div class="confirm-copy">
                <p class="confirm-kicker">Confirmation requise</p>
                <h2 id="confirmTitle" class="confirm-title">Confirmer l action</h2>
                <p id="confirmMessage" class="confirm-message">Voulez-vous continuer ?</p>
            </div>
        </div>
        <div class="confirm-actions">
            <button id="confirmCancel" type="button" class="btn btn-contour">Annuler</button>
            <button id="confirmAccept" type="button" class="btn btn-danger">Confirmer</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/water-animations.js"></script>
