<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<style type="text/css">
	.legend{color: #6e2b2d!important; font-size: 32px !important;font-weight: normal!important;}
	.control-group{margin-bottom: 0px!important;}
	.control-label{width: 50%!important; float: left;text-transform: capitalize !important;}
	textarea {height: 50px !important;width: 30% !important;}
	.divPrivacidad{clear: both;margin-top: 10px;}
	.divPrivacidad a{color: #6e2b2d!important;}
	.g-recaptcha {clear: both;}
	#layout-column_column-3{width: 90%!important;}
	.portlet-borderless-container{border-radius: 10px!important;}
	.btn.btn-primary{background: #6e2b2d!important;color: #ffffff !important;font-weight: bold;}

	.portlet-borderless.Ibercarto-form-portlet legend{border-bottom: 1px solid #6e2b2d;}
	.portlet-borderless.Ibercarto-form-portlet p.descriptionSub{border-bottom: 1px solid #6e2b2d;width: 80%;}
	.portlet-borderless.Ibercarto-form-portlet label{font-size: 1.2em;}
	.portlet-borderless.Ibercarto-form-portlet input[type="text"]{font-size: 1.2em;width:500px;}
	.portlet-borderless.Ibercarto-form-portlet .control-label {width: 30%!important; text-transform: none !important;font-weight: normal !important;}
	.portlet-borderless.Ibercarto-form-portlet .aui-field-select.optional {width: 50px;padding: 3px;}
	.portlet-borderless.Ibercarto-form-portlet p {font-size: 1.3em; margin-bottom: 20px;}
	.portlet-borderless.Ibercarto-form-portlet div.obligatorio {display:none;}
	.portlet-borderless.Ibercarto-form-portlet textarea {height: 150px !important;width: 40% !important;}
	@media (max-width: 377px) {
	.ign-cnig-content{margin-top: 20px;}
	.portlet-borderless.Ibercarto-form-portlet p.description {border-bottom: 0.5px dashed #e5e5e5;padding-bottom: 10px;}
	.portlet-borderless.Ibercarto-form-portlet .control-group {clear: both;}
	.portlet-borderless.Ibercarto-form-portlet .control-label {width: 100% !important;float: none;}
	.portlet-borderless.Ibercarto-form-portlet textarea,
	.portlet-borderless.Ibercarto-form-portlet input {width: 100% !important; max-width: 100% !important;}
	.portlet-borderless.Ibercarto-form-portlet select {width: 100% !important; max-width: 100% !important;}
	.portlet-borderless.Ibercarto-form-portlet .g-recaptcha, 
	.portlet-borderless.Ibercarto-form-portlet #rc-imageselect {transform: scale(0.93);transform-origin: 0 0;}
</style>

<%
String title = LocalizationUtil.getPreferencesValue(portletPreferences, "title", themeDisplay.getLanguageId());
String description = LocalizationUtil.getPreferencesValue(portletPreferences, "description", themeDisplay.getLanguageId());
boolean requireCaptcha = GetterUtil.getBoolean(portletPreferences.getValue("requireCaptcha", StringPool.BLANK));
String successURL = portletPreferences.getValue("successURL", StringPool.BLANK);
String successTxt = portletPreferences.getValue("successTxt", StringPool.BLANK);
if(successTxt.isEmpty()){
	successTxt = "Su solicitud se ha enviado correctamente.";
}
%>

<portlet:actionURL var="saveDataURL">
	<portlet:param name="<%= ActionRequest.ACTION_NAME %>" value="saveData" />
</portlet:actionURL>
<aui:form action="<%= saveDataURL %>" method="post" name="fm">
	<c:if test="<%= Validator.isNull(successURL) %>">
		<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
	</c:if>

	<aui:fieldset label="<%= HtmlUtil.escape(title) %>">
		<c:if test="<%= Validator.isNotNull(description) %>">
			<p class="description"><%= HtmlUtil.escape(description) %></p>
		</c:if>

		<%-- <liferay-ui:success key="success" message="Su solicitud se ha enviado correctamente. En breve le confirmaremos si dispone de plaza en la actividad. Gracias por su interés" /> --%>
		<liferay-ui:success key="success" message="<%=successTxt%>" />

		<liferay-ui:error exception="<%= CaptchaMaxChallengesException.class %>" message="maximum-number-of-captcha-attempts-exceeded" />
		<liferay-ui:error exception="<%= CaptchaTextException.class %>" message="text-verification-failed" />
		<liferay-ui:error key="error" message="an-error-occurred-while-sending-the-form-information" />

		<c:if test='<%= PortletPropsValues.VALIDATION_SCRIPT_ENABLED && SessionErrors.contains(renderRequest, "validationScriptError") %>'>
			<liferay-util:include page="/script_error.jsp" />
		</c:if>

		<%
		int i = 1;

		String fieldName = "field" + i;
		String fieldLabel = LocalizationUtil.getPreferencesValue(portletPreferences, "fieldLabel" + i, themeDisplay.getLanguageId());
		boolean fieldOptional = PrefsParamUtil.getBoolean(portletPreferences, request, "fieldOptional" + i, false);
		String fieldValue = ParamUtil.getString(request, fieldName);

		while ((i == 1) || Validator.isNotNull(fieldLabel)) {
			String fieldType = portletPreferences.getValue("fieldType" + i, "text");
			String fieldOptions = LocalizationUtil.getPreferencesValue(portletPreferences, "fieldOptions" + i, themeDisplay.getLanguageId());
			String fieldValidationScript = portletPreferences.getValue("fieldValidationScript" + i, StringPool.BLANK);
			String fieldValidationErrorMessage = portletPreferences.getValue("fieldValidationErrorMessage" + i, StringPool.BLANK);

			switch(i){
				case 1: 
		%>
			<p class="descriptionSub">Datos personales</p>
		<%		
					break;
				case 11: 
		%>
			<p class="descriptionSub">Profesionales</p>
		<%		
					break;
				case 13: 
		%>
			<p class="descriptionSub">Estudiantes</p>
		<%		
					break;
			}
			
		
		%>

			<c:if test="<%= PortletPropsValues.VALIDATION_SCRIPT_ENABLED %>">
				<liferay-ui:error key='<%= "error" + fieldLabel %>' message="<%= fieldValidationErrorMessage %>" />

				<c:if test="<%= Validator.isNotNull(fieldValidationScript) %>">
					<div class="hide" id="<portlet:namespace />validationError<%= fieldName %>">
						<span class="alert alert-error"><%= fieldValidationErrorMessage %></span>
					</div>
				</c:if>
			</c:if>

			<c:if test="<%= !fieldOptional %>">
				<div class="hide" id="<portlet:namespace />fieldOptionalError<%= fieldName %>">
					<span class="alert alert-error"><liferay-ui:message key="this-field-is-mandatory" /></span>
				</div>
			</c:if>

			<c:choose>
				<c:when test='<%= fieldType.equals("paragraph") %>'>
					<p class="lfr-webform" id="<portlet:namespace /><%= fieldName %>"><%= HtmlUtil.escape(fieldOptions) %></p>
				</c:when>
				<c:when test='<%= fieldType.equals("text") %>'>
					<aui:input cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" value="<%= HtmlUtil.escape(fieldValue) %>" maxlength="100"/>
				</c:when>
				<c:when test='<%= fieldType.equals("textarea") %>'>
					<aui:input cssClass='<%= (fieldOptional ? "optional" : StringPool.BLANK) %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" type="textarea" value="<%= HtmlUtil.escape(fieldValue) %>" wrap="soft" wrapperCssClass="lfr-textarea-container" />
				</c:when>
				<c:when test='<%= fieldType.equals("checkbox") %>'>
					<aui:input cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" type="checkbox" value="<%= GetterUtil.getBoolean(fieldValue) %>" />
				</c:when>
				<c:when test='<%= fieldType.equals("radio") %>'>
					<aui:field-wrapper cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>">

						<%
						for (String fieldOptionValue : WebFormUtil.split(fieldOptions)) {
						%>

							<aui:input checked="<%= fieldValue.equals(fieldOptionValue) %>" label="<%= HtmlUtil.escape(fieldOptionValue) %>" name="<%= fieldName %>" type="radio" value="<%= HtmlUtil.escape(fieldOptionValue) %>" />

						<%
						}
						%>

					</aui:field-wrapper>
				</c:when>
				<c:when test='<%= fieldType.equals("options") %>'>
					<aui:select cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>">

						<%
						for (String fieldOptionValue : WebFormUtil.split(fieldOptions)) {
						%>

							<aui:option selected="<%= fieldValue.equals(fieldOptionValue) %>" value="<%= HtmlUtil.escape(fieldOptionValue) %>"><%= HtmlUtil.escape(fieldOptionValue) %></aui:option>

						<%
						}
						%>

					</aui:select>
				</c:when>
			</c:choose>

		<%
			i++;

			fieldName = "field" + i;
			fieldLabel = LocalizationUtil.getPreferencesValue(portletPreferences, "fieldLabel" + i, themeDisplay.getLanguageId());
			fieldOptional = PrefsParamUtil.getBoolean(portletPreferences, request, "fieldOptional" + i, false);
			fieldValue = ParamUtil.getString(request, fieldName);
		}
		%>
			<p class="description" style="margin-top:20px;">La fecha límite para la inscripción en el IX Encuentro de Ibercarto será el <strong>23 de marzo de 2022</strong>.</p>
			
			<div class="obligatorio">* Campo obligatorio </div>
			
			<div class="hide portlet-msg-error" id="errorPrivacidad"><p style="font-size:18px;">Es obligatorio aceptar la política de privacidad.</p></div>
			<div class="divPrivacidad" style="margin-left: 10%;"><p><input type="checkbox" id="checkPoliticaPrivacidad"> He leído y acepto la <a href="http://www.ign.es/web/ign/portal/info-aviso-legal" target="_blank">Política de privacidad</a> del Instituto Geográfico Nacional</p></div>

			<div class="g-recaptcha" style="margin-left: 10%;" data-sitekey="6LcIDDseAAAAAFpzP8uxW-Bu4O3ag5A_9Q-4niIo"></div>  
			 <!-- <div class="g-recaptcha" data-sitekey="6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"></div> --> <!--  test -->
<%-- 		<c:if test="<%= requireCaptcha %>">
			<portlet:resourceURL var="captchaURL">
				<portlet:param name="<%= Constants.CMD %>" value="captcha" />
			</portlet:resourceURL>

			<liferay-ui:captcha url="<%= captchaURL %>" />
		</c:if>
 --%>
		<div style="text-align: center;">
			<aui:button onClick="" type="submit" value="send" />
		</div>
	</aui:fieldset>
</aui:form>

<aui:script use="aui-base,selector-css3">
	var form = A.one('#<portlet:namespace />fm');

	if (form) {
		form.on(
			'submit',
			function(event) {
				var validationErrors = false;
				var acepto = A.one("#checkPoliticaPrivacidad");
				if(!acepto.attr('checked')){
					A.one("#errorPrivacidad").show();
					validationErrors = true;
				} else {
					A.one("#errorPrivacidad").hide();
					var keys = [];
	
					var fieldLabels = {};
					var fieldOptional = {};
					var fieldValidationErrorMessages = {};
					var fieldValidationFunctions = {};
					var fieldsMap = {};
	
					<%
					int i = 1;
	
					String fieldName = "field" + i;
					String fieldLabel = portletPreferences.getValue("fieldLabel" + i, StringPool.BLANK);
	
					while ((i == 1) || Validator.isNotNull(fieldLabel)) {
						boolean fieldOptional = PrefsParamUtil.getBoolean(portletPreferences, request, "fieldOptional" + i, false);
						String fieldType = portletPreferences.getValue("fieldType" + i, "text");
						String fieldValidationScript = portletPreferences.getValue("fieldValidationScript" + i, StringPool.BLANK);
						String fieldValidationErrorMessage = portletPreferences.getValue("fieldValidationErrorMessage" + i, StringPool.BLANK);
					%>
	
						var key = '<%= fieldName %>';
	
						keys[<%= i %>] = key;
	
						fieldLabels[key] = '<%= HtmlUtil.escape(fieldLabel) %>';
						fieldValidationErrorMessages[key] = '<%= fieldValidationErrorMessage %>';
	
						function fieldValidationFunction<%= i %>(currentFieldValue, fieldsMap) {
							<c:choose>
								<c:when test="<%= PortletPropsValues.VALIDATION_SCRIPT_ENABLED && Validator.isNotNull(fieldValidationScript) %>">
									<%= fieldValidationScript %>
								</c:when>
								<c:otherwise>
									return true;
								</c:otherwise>
							</c:choose>
						};
	
						fieldOptional[key] = <%= fieldOptional %>;
						fieldValidationFunctions[key] = fieldValidationFunction<%= i %>;
	
						<c:choose>
							<c:when test='<%= fieldType.equals("radio") %>'>
								var radioButton = A.one('input[name=<portlet:namespace />field<%= i %>]:checked');
	
								fieldsMap[key] = '';
	
								if (radioButton) {
									fieldsMap[key] = radioButton.val();
								}
							</c:when>
							<c:otherwise>
								var inputField = A.one('#<portlet:namespace />field<%= i %>');
	
								fieldsMap[key] = (inputField && inputField.val()) || '';
							</c:otherwise>
						</c:choose>
	
					<%
						i++;
	
						fieldName = "field" + i;
						fieldLabel = portletPreferences.getValue("fieldLabel" + i, "");
					}
					%>
	
					for (var i = 1; i < keys.length; i++) {
						var key = keys [i];
	
						var currentFieldValue = fieldsMap[key];
	
						var optionalFieldError = A.one('#<portlet:namespace />fieldOptionalError' + key);
						var validationError = A.one('#<portlet:namespace />validationError' + key);
	
						if (!fieldOptional[key] && currentFieldValue.match(/^\s*$/)) {
							validationErrors = true;
	
							A.all('.alert-success').hide();
	
							if (optionalFieldError) {
								optionalFieldError.show();
							}
						}
						else if (!fieldValidationFunctions[key](currentFieldValue, fieldsMap)) {
							validationErrors = true;
	
							A.all('.alert-success').hide();
	
							if (optionalFieldError) {
								optionalFieldError.hide();
							}
	
							if (validationError) {
								validationError.show();
							}
						}
						else {
							if (optionalFieldError) {
								optionalFieldError.hide();
							}
	
							if (validationError) {
								validationError.hide();
							}
						}
					}
				}

				if (validationErrors) {
					event.halt();
					event.stopImmediatePropagation();
				}
			}
		);
	}
</aui:script>