<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:if test="${not empty flashMessage}">
    <div class="alert ${flashType == 'success' ? 'alert-success' : 'alert-error'}">
        ${flashMessage}
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-error">
        ${error}
    </div>
</c:if>

