<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
                <footer class="app-footer">
                    <span><fmt:message key="app.footer"/></span>
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
                <p class="confirm-kicker"><fmt:message key="confirm.kicker"/></p>
                <h2 id="confirmTitle" class="confirm-title"><fmt:message key="confirm.title"/></h2>
                <p id="confirmMessage" class="confirm-message"><fmt:message key="confirm.message"/></p>
            </div>
        </div>
        <div class="confirm-actions">
            <button id="confirmCancel" type="button" class="btn btn-contour"><fmt:message key="confirm.cancel"/></button>
            <button id="confirmAccept" type="button" class="btn btn-danger"><fmt:message key="confirm.confirm"/></button>
        </div>
    </div>
</div>

<div id="settingsModal" class="settings-layer" hidden>
    <div class="settings-backdrop" data-settings-close></div>
    <div class="settings-dialog" role="dialog" aria-modal="true" aria-labelledby="settingsTitle">
        <div class="settings-header">
            <h2 id="settingsTitle" class="settings-title"><fmt:message key="settings.title"/></h2>
            <button class="settings-close" type="button" data-settings-close aria-label="<fmt:message key="settings.close"/>">&times;</button>
        </div>
        <div class="settings-body">
            <div class="settings-group">
                <span class="settings-group-label"><fmt:message key="settings.display"/></span>
                <div class="settings-row">
                    <div class="settings-row-info">
                        <span class="settings-row-title"><fmt:message key="settings.dark_mode"/></span>
                        <span class="settings-row-desc"><fmt:message key="settings.dark_mode.desc"/></span>
                    </div>
                    <label class="settings-toggle">
                        <input type="checkbox" id="settingsDarkMode">
                        <span class="settings-toggle-track"></span>
                    </label>
                </div>
            </div>
            <div class="settings-group">
                <span class="settings-group-label"><fmt:message key="settings.langue"/></span>
                <div class="settings-row">
                    <div class="settings-row-info">
                        <span class="settings-row-title"><fmt:message key="settings.langue.title"/></span>
                        <span class="settings-row-desc"><fmt:message key="settings.langue.desc"/></span>
                    </div>
                    <div class="settings-lang-buttons">
                        <button class="lang-btn" type="button" data-lang="fr" data-settings-close><fmt:message key="settings.langue.fr"/></button>
                        <button class="lang-btn" type="button" data-lang="en" data-settings-close><fmt:message key="settings.langue.en"/></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<fmt:message key="flash.success" var="i18nFlashSuccess"/>
<fmt:message key="flash.error" var="i18nFlashError"/>
<fmt:message key="flash.warning" var="i18nFlashWarning"/>
<fmt:message key="flash.info" var="i18nFlashInfo"/>
<fmt:message key="confirm.title" var="i18nConfirmTitle"/>
<fmt:message key="confirm.message" var="i18nConfirmMessage"/>
<fmt:message key="confirm.confirm" var="i18nConfirmConfirm"/>
<fmt:message key="confirm.cancel" var="i18nConfirmCancel"/>
<fmt:message key="toast.close.aria" var="i18nToastCloseAria"/>
<fmt:message key="login.password.show" var="i18nPasswordShow"/>
<fmt:message key="login.password.hide" var="i18nPasswordHide"/>
<script>
var I18N = {
    toast: {
        titles: {
            success: '${i18nFlashSuccess}',
            error: '${i18nFlashError}',
            warning: '${i18nFlashWarning}',
            info: '${i18nFlashInfo}'
        },
        closeAria: '${i18nToastCloseAria}'
    },
    confirm: {
        title: '${i18nConfirmTitle}',
        message: '${i18nConfirmMessage}',
        confirm: '${i18nConfirmConfirm}',
        cancel: '${i18nConfirmCancel}'
    },
    password: {
        show: '${i18nPasswordShow}',
        hide: '${i18nPasswordHide}'
    }
};
</script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/water-animations.js"></script>
