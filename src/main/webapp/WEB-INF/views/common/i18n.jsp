<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:choose>
    <c:when test="${cookie['sgda-lang'] != null && cookie['sgda-lang'].value == 'en'}">
        <fmt:setLocale value="en_US" scope="session"/>
        <c:set var="currentLang" value="en" scope="request"/>
    </c:when>
    <c:otherwise>
        <fmt:setLocale value="fr_FR" scope="session"/>
        <c:set var="currentLang" value="fr" scope="request"/>
    </c:otherwise>
</c:choose>
<fmt:setBundle basename="com.sgda.i18n.messages" scope="session"/>
