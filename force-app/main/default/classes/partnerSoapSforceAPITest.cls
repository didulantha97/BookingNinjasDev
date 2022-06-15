@isTest
public with sharing class partnerSoapSforceAPITest {

    @IsTest
    private static void coverConvertLead() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().convertLead(null);
        Test.stopTest();
    }
    @IsTest
    private static void coverDML() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().delete_x(null);
        new partnerSoapSforceAPI.Soap().update_x(null);
        new partnerSoapSforceAPI.Soap().emptyRecycleBin(null);
        new partnerSoapSforceAPI.Soap().merge_x(null);
        new partnerSoapSforceAPI.Soap().create(null);
        new partnerSoapSforceAPI.Soap().deleteByExample(null);
        Test.stopTest();
    }
    @IsTest
    private static void coverUserActions() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().login('test', 'test');
        new partnerSoapSforceAPI.Soap().getUserInfo();
        new partnerSoapSforceAPI.Soap().logout();
        new partnerSoapSforceAPI.Soap().invalidateSessions(null);
        new partnerSoapSforceAPI.Soap().resetPassword(null);
        new partnerSoapSforceAPI.Soap().setPassword(null, null);
        new partnerSoapSforceAPI.Soap().undelete_x(null);
        Test.stopTest();
    }
    @IsTest
    private static void coverQuery() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().queryMore('');
        new partnerSoapSforceAPI.Soap().queryAll('');
        Test.stopTest();
    }
    @IsTest
    private static void coverProcess() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().process(null);
        Test.stopTest();
    }

    @IsTest
    private static void coverFindDuplicates() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().findDuplicates(null);
        new partnerSoapSforceAPI.Soap().findDuplicatesByIds(null);
        Test.stopTest();
    }

    @IsTest
    private static void coverGetServerTimestamp() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().getServerTimestamp();
        Test.stopTest();
    }

    @IsTest
    private static void coverRetrive() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().retrieveQuickActionTemplates(null, null);
        new partnerSoapSforceAPI.Soap().retrieve_x(null, null, null);
        Test.stopTest();
    }

    @IsTest
    private static void coverDescribeData() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        new partnerSoapSforceAPI.Soap().describeAllTabs();
        new partnerSoapSforceAPI.Soap().describeDataCategoryGroupStructures(null, true);
        new partnerSoapSforceAPI.Soap().describeDataCategoryGroups(null);
        new partnerSoapSforceAPI.Soap().describeGlobal();
        new partnerSoapSforceAPI.Soap().describeGlobalTheme();
        new partnerSoapSforceAPI.Soap().describeApprovalLayout(null, null);
        new partnerSoapSforceAPI.Soap().describePrimaryCompactLayouts(null);
        new partnerSoapSforceAPI.Soap().describeLayout(null, null, null);
        new partnerSoapSforceAPI.Soap().describeSearchableEntities(null);
        new partnerSoapSforceAPI.Soap().describeAppMenu(null, null);
        new partnerSoapSforceAPI.Soap().describeSObjectListViews(null, null, null, null, null);
        new partnerSoapSforceAPI.Soap().describeDataCategoryMappings();
        new partnerSoapSforceAPI.Soap().describeSoftphoneLayout();
        new partnerSoapSforceAPI.Soap().describeSearchScopeOrder(null);
        new partnerSoapSforceAPI.Soap().describeSearchLayouts(null);
        new partnerSoapSforceAPI.Soap().describeSObject(null);
        new partnerSoapSforceAPI.Soap().describeVisualForce(null, null);
        new partnerSoapSforceAPI.Soap().describeNouns(null, null, null);
        new partnerSoapSforceAPI.Soap().describeTheme(null);
        new partnerSoapSforceAPI.Soap().describeKnowledgeSettings();
        Test.stopTest();
    }

    private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof partnerSoapSforceAPI.retrieve_element)
                response.put('response_x', new partnerSoapSforceAPI.retrieveResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeAllTabs_element)
                response.put('response_x', new partnerSoapSforceAPI.describeAllTabsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeDataCategoryGroupStructures_element)
                response.put('response_x', new partnerSoapSforceAPI.describeDataCategoryGroupStructuresResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeDataCategoryGroups_element)
                response.put('response_x', new partnerSoapSforceAPI.describeDataCategoryGroupsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.findDuplicates_element)
                response.put('response_x', new partnerSoapSforceAPI.findDuplicatesResponse_element());
            else if(request instanceof partnerSoapSforceAPI.process_element)
                response.put('response_x', new partnerSoapSforceAPI.processResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeGlobal_element)
                response.put('response_x', new partnerSoapSforceAPI.describeGlobalResponse_element());
            else if(request instanceof partnerSoapSforceAPI.getUserInfo_element)
                response.put('response_x', new partnerSoapSforceAPI.getUserInfoResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeGlobalTheme_element)
                response.put('response_x', new partnerSoapSforceAPI.describeGlobalThemeResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeApprovalLayout_element)
                response.put('response_x', new partnerSoapSforceAPI.describeApprovalLayoutResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describePrimaryCompactLayouts_element)
                response.put('response_x', new partnerSoapSforceAPI.describePrimaryCompactLayoutsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.queryMore_element)
                response.put('response_x', new partnerSoapSforceAPI.queryMoreResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeSearchableEntities_element)
                response.put('response_x', new partnerSoapSforceAPI.describeSearchableEntitiesResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeLayoutResponse_element)
                response.put('response_x', new partnerSoapSforceAPI.describeLayoutResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeAppMenu_element)
                response.put('response_x', new partnerSoapSforceAPI.describeAppMenuResponse_element());
            else if(request instanceof partnerSoapSforceAPI.convertLead_element)
                response.put('response_x', new partnerSoapSforceAPI.convertLeadResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeSObjectListViews_element)
                response.put('response_x', new partnerSoapSforceAPI.describeSObjectListViewsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.delete_element)
                response.put('response_x', new partnerSoapSforceAPI.deleteResponse_element());
            else if(request instanceof partnerSoapSforceAPI.login_element)
                response.put('response_x', new partnerSoapSforceAPI.loginResponse_element());
            else if(request instanceof partnerSoapSforceAPI.login_element)
                response.put('response_x', new partnerSoapSforceAPI.loginResponse_element());
            else if(request instanceof partnerSoapSforceAPI.queryAll_element)
                response.put('response_x', new partnerSoapSforceAPI.queryAllResponse_element());
            else if(request instanceof partnerSoapSforceAPI.update_element)
                response.put('response_x', new partnerSoapSforceAPI.updateResponse_element());
            else if(request instanceof partnerSoapSforceAPI.emptyRecycleBin_element)
                response.put('response_x', new partnerSoapSforceAPI.emptyRecycleBinResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeSearchScopeOrder_element)
                response.put('response_x', new partnerSoapSforceAPI.describeSearchScopeOrderResponse_element());
            else if(request instanceof partnerSoapSforceAPI.logout_element)
                response.put('response_x', new partnerSoapSforceAPI.logoutResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeDataCategoryMappings_element)
                response.put('response_x', new partnerSoapSforceAPI.describeDataCategoryMappingsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.invalidateSessions_element)
                response.put('response_x', new partnerSoapSforceAPI.invalidateSessionsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.merge_element)
                response.put('response_x', new partnerSoapSforceAPI.mergeResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeSearchLayouts_element)
                response.put('response_x', new partnerSoapSforceAPI.describeSearchLayoutsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.create_element)
                response.put('response_x', new partnerSoapSforceAPI.createResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeSoftphoneLayout_element)
                response.put('response_x', new partnerSoapSforceAPI.describeSoftphoneLayoutResponse_element());
            else if(request instanceof partnerSoapSforceAPI.resetPassword_element)
                response.put('response_x', new partnerSoapSforceAPI.resetPasswordResponse_element());
            else if(request instanceof partnerSoapSforceAPI.setPassword_element)
                response.put('response_x', new partnerSoapSforceAPI.setPasswordResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeSObject_element)
                response.put('response_x', new partnerSoapSforceAPI.describeSObjectResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeVisualForce_element)
                response.put('response_x', new partnerSoapSforceAPI.describeVisualForceResponse_element());
            else if(request instanceof partnerSoapSforceAPI.getServerTimestamp_element)
                response.put('response_x', new partnerSoapSforceAPI.getServerTimestampResponse_element());
            else if(request instanceof partnerSoapSforceAPI.retrieveQuickActionTemplates_element)
                response.put('response_x', new partnerSoapSforceAPI.retrieveQuickActionTemplatesResponse_element());
            else if(request instanceof partnerSoapSforceAPI.findDuplicatesByIds_element)
                response.put('response_x', new partnerSoapSforceAPI.findDuplicatesByIdsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeLayout_element)
                response.put('response_x', new partnerSoapSforceAPI.describeLayoutResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeNouns_element)
                response.put('response_x', new partnerSoapSforceAPI.describeNounsResponse_element());
            else if(request instanceof partnerSoapSforceAPI.deleteByExample_element)
                response.put('response_x', new partnerSoapSforceAPI.deleteByExampleResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeTheme_element)
                response.put('response_x', new partnerSoapSforceAPI.describeThemeResponse_element());
            else if(request instanceof partnerSoapSforceAPI.retrieve_element)
                response.put('response_x', new partnerSoapSforceAPI.retrieveResponse_element());
            else if(request instanceof partnerSoapSforceAPI.undelete_element)
                response.put('response_x', new partnerSoapSforceAPI.undeleteResponse_element());
            else if(request instanceof partnerSoapSforceAPI.describeKnowledgeSettings_element)
                response.put('response_x', new partnerSoapSforceAPI.describeKnowledgeSettingsResponse_element());

            System.debug('aaa');
            return;
        }
    }


    @IsTest
    private static void coverGeneratedCodeTypes() {
        // Reference types
        Test.startTest();
        new partnerSoapSforceAPI();
        new partnerSoapSforceAPI.InvalidateSessionsResult();
        new partnerSoapSforceAPI.describePrimaryCompactLayoutsResponse_element();
        new partnerSoapSforceAPI.changeOwnPassword_element();
        new partnerSoapSforceAPI.DescribeAppMenuResult();
        new partnerSoapSforceAPI.DescribeColor();
        new partnerSoapSforceAPI.MergeResult();
        new partnerSoapSforceAPI.describeDataCategoryGroupStructures_element();
        new partnerSoapSforceAPI.queryResponse_element();
        new partnerSoapSforceAPI.CallOptions_element();
        new partnerSoapSforceAPI.SaveResult();
        new partnerSoapSforceAPI.describeDataCategoryGroups_element();
        new partnerSoapSforceAPI.ExtendedErrorDetails();
        new partnerSoapSforceAPI.upsert_element();
        new partnerSoapSforceAPI.updateResponse_element();
        new partnerSoapSforceAPI.MergeRequest();
        new partnerSoapSforceAPI.RecordTypeInfo();
        new partnerSoapSforceAPI.sendEmailResponse_element();
        new partnerSoapSforceAPI.DescribeRelatedContentItem();
        new partnerSoapSforceAPI.describeSObjectsResponse_element();
        new partnerSoapSforceAPI.DescribeQuickActionResult();
        new partnerSoapSforceAPI.JunctionIdListNames();
        new partnerSoapSforceAPI.UpsertResult();
        new partnerSoapSforceAPI.deleteByExampleResponse_element();
        new partnerSoapSforceAPI.describeQuickActionsResponse_element();
        new partnerSoapSforceAPI.LeadConvert();
        new partnerSoapSforceAPI.RenderEmailTemplateError();
        new partnerSoapSforceAPI.DescribeAvailableQuickActionResult();
        new partnerSoapSforceAPI.EmptyRecycleBinResult();
        new partnerSoapSforceAPI.RenderStoredEmailTemplateRequest();
        new partnerSoapSforceAPI.SingleEmailMessage();
        new partnerSoapSforceAPI.DescribeSearchScopeOrderResult();
        new partnerSoapSforceAPI.DescribeSoftphoneScreenPopOption();
        new partnerSoapSforceAPI.describeSearchScopeOrder_element();
        new partnerSoapSforceAPI.create_element();
        new partnerSoapSforceAPI.LimitInfoHeader_element();
        new partnerSoapSforceAPI.describeDataCategoryMappingsResponse_element();
        new partnerSoapSforceAPI.MassEmailMessage();
        new partnerSoapSforceAPI.renderStoredEmailTemplateResponse_element();
        new partnerSoapSforceAPI.NameCaseValue();
        new partnerSoapSforceAPI.describeApprovalLayout_element();
        new partnerSoapSforceAPI.SetPasswordResult();
        new partnerSoapSforceAPI.retrieveQuickActionTemplates_element();
        new partnerSoapSforceAPI.retrieve_element();
        new partnerSoapSforceAPI.DeleteResult();
        new partnerSoapSforceAPI.SearchLayoutField();
        new partnerSoapSforceAPI.DescribeQuickActionDefaultValue();
        new partnerSoapSforceAPI.describePrimaryCompactLayouts_element();
        new partnerSoapSforceAPI.describeGlobalThemeResponse_element();
        new partnerSoapSforceAPI.query_element();
        new partnerSoapSforceAPI.describeSObjectListViewsResponse_element();
        new partnerSoapSforceAPI.DescribeVisualForceResult();
        new partnerSoapSforceAPI.DescribeSoftphoneLayoutInfoField();
        new partnerSoapSforceAPI.DebuggingHeader_element();
        new partnerSoapSforceAPI.PackageVersion();
        new partnerSoapSforceAPI.DataCategoryGroupSobjectTypePair();
        new partnerSoapSforceAPI.SearchRecord();
        new partnerSoapSforceAPI.EntityErrorMetadata();
        new partnerSoapSforceAPI.DescribeLayoutButtonSection();
        new partnerSoapSforceAPI.AllOrNoneHeader_element();
        new partnerSoapSforceAPI.DescribeSoftphoneLayoutResult();
        new partnerSoapSforceAPI.describeDataCategoryMappings_element();
        new partnerSoapSforceAPI.LocaleOptions_element();
        new partnerSoapSforceAPI.DescribeDataCategoryMappingResult();
        new partnerSoapSforceAPI.DescribeLayoutSaveOption();
        new partnerSoapSforceAPI.describeSearchLayoutsResponse_element();
        new partnerSoapSforceAPI.UserTerritoryDeleteHeader_element();
        new partnerSoapSforceAPI.FindDuplicatesResult();
        new partnerSoapSforceAPI.DescribeAnimationRule();
        new partnerSoapSforceAPI.describeSearchLayouts_element();
        new partnerSoapSforceAPI.address();
        new partnerSoapSforceAPI.sendEmail_element();
        new partnerSoapSforceAPI.LogInfo();
        new partnerSoapSforceAPI.DeletedRecord();
        new partnerSoapSforceAPI.emptyRecycleBin_element();
        new partnerSoapSforceAPI.SearchResult();
        new partnerSoapSforceAPI.DescribeColumn();
        new partnerSoapSforceAPI.describeLayoutResponse_element();
        new partnerSoapSforceAPI.login_element();
        new partnerSoapSforceAPI.undelete_element();
        new partnerSoapSforceAPI.ChangeOwnPasswordResult();
        new partnerSoapSforceAPI.DescribeCompactLayoutsResult();
        new partnerSoapSforceAPI.DescribeDataCategoryGroupStructureResult();
        new partnerSoapSforceAPI.GetUserInfoResult();
        new partnerSoapSforceAPI.EmailFileAttachment();
        new partnerSoapSforceAPI.sendEmailMessageResponse_element();
        new partnerSoapSforceAPI.findDuplicates_element();
        new partnerSoapSforceAPI.getServerTimestamp_element();
        new partnerSoapSforceAPI.Email();
        new partnerSoapSforceAPI.DescribeIcon();
        new partnerSoapSforceAPI.executeListView_element();
        new partnerSoapSforceAPI.deleteByExample_element();
        new partnerSoapSforceAPI.describeGlobalResponse_element();
        new partnerSoapSforceAPI.RenderEmailTemplateBodyResult();
        new partnerSoapSforceAPI.EmailHeader_element();
        new partnerSoapSforceAPI.getServerTimestampResponse_element();
        new partnerSoapSforceAPI.findDuplicatesByIdsResponse_element();
        new partnerSoapSforceAPI.ReportChartComponent();
        new partnerSoapSforceAPI.DescribeQuickActionListItemResult();
        new partnerSoapSforceAPI.describeAvailableQuickActionsResponse_element();
        new partnerSoapSforceAPI.describeSObjects_element();
        new partnerSoapSforceAPI.undeleteResponse_element();
        new partnerSoapSforceAPI.describePathAssistantsResponse_element();
        new partnerSoapSforceAPI.OwnerChangeOptions_element();
        new partnerSoapSforceAPI.DescribeLayoutItem();
        new partnerSoapSforceAPI.describeAppMenuResponse_element();
        new partnerSoapSforceAPI.resetPasswordResponse_element();
        new partnerSoapSforceAPI.Canvas();
        new partnerSoapSforceAPI.ProcessResult();
        new partnerSoapSforceAPI.RelatedListColumn();
        new partnerSoapSforceAPI.findDuplicatesResponse_element();
        new partnerSoapSforceAPI.FieldLevelSearchMetadata();
        new partnerSoapSforceAPI.MatchRecord();
        new partnerSoapSforceAPI.SoqlSubQueryCondition();
        new partnerSoapSforceAPI.describeGlobal_element();
        new partnerSoapSforceAPI.DescribeApprovalLayoutResult();
        new partnerSoapSforceAPI.describeApprovalLayoutResponse_element();
        new partnerSoapSforceAPI.DescribeLayoutSection();
        new partnerSoapSforceAPI.setPasswordResponse_element();
        new partnerSoapSforceAPI.ActionOverride();
        new partnerSoapSforceAPI.processResponse_element();
        new partnerSoapSforceAPI.DescribeGlobalResult();
        new partnerSoapSforceAPI.sendEmailMessage_element();
        new partnerSoapSforceAPI.searchResponse_element();
        new partnerSoapSforceAPI.DescribeLayoutResult();
        new partnerSoapSforceAPI.changeOwnPasswordResponse_element();
        new partnerSoapSforceAPI.DescribePathAssistant();
        new partnerSoapSforceAPI.AdditionalInformationMap();
        new partnerSoapSforceAPI.FilteredLookupInfo();
        new partnerSoapSforceAPI.MatchResult();
        new partnerSoapSforceAPI.DescribeCompactLayout();
        new partnerSoapSforceAPI.CurrencyConversionHeader_element();
        new partnerSoapSforceAPI.Field();
        new partnerSoapSforceAPI.invalidateSessionsResponse_element();
        new partnerSoapSforceAPI.describeSoftphoneLayoutResponse_element();
        new partnerSoapSforceAPI.PicklistEntry();
        new partnerSoapSforceAPI.DescribeSearchLayoutResult();
        new partnerSoapSforceAPI.AllowFieldTruncationHeader_element();
        new partnerSoapSforceAPI.mergeResponse_element();
        new partnerSoapSforceAPI.DescribeSoqlListViewParams();
        new partnerSoapSforceAPI.ExecuteListViewRequest();
        new partnerSoapSforceAPI.DescribePathAssistantField();
        new partnerSoapSforceAPI.DescribeDataCategoryGroupResult();
        new partnerSoapSforceAPI.DescribeThemeItem();
        new partnerSoapSforceAPI.RenderStoredEmailTemplateResult();
        new partnerSoapSforceAPI.DebuggingInfo_element();
        new partnerSoapSforceAPI.describeAllTabsResponse_element();
        new partnerSoapSforceAPI.DescribeSObjectResult();
        new partnerSoapSforceAPI.deleteResponse_element();
        new partnerSoapSforceAPI.LeadConvertResult();
        new partnerSoapSforceAPI.deleteResponse_element();
        new partnerSoapSforceAPI.KnowledgeSettings();
        new partnerSoapSforceAPI.StreamingEnabledHeader_element();
        new partnerSoapSforceAPI.describeKnowledgeSettings_element();
        new partnerSoapSforceAPI.LoginScopeHeader_element();
        new partnerSoapSforceAPI.update_element();
        new partnerSoapSforceAPI.ChildRelationship();
        new partnerSoapSforceAPI.RelatedList();
        new partnerSoapSforceAPI.ChangeEventHeader();
        new partnerSoapSforceAPI.describeNouns_element();
        new partnerSoapSforceAPI.location();
        new partnerSoapSforceAPI.renderEmailTemplate_element();
        new partnerSoapSforceAPI.DuplicateRuleHeader_element();
        new partnerSoapSforceAPI.DataCategory();
        new partnerSoapSforceAPI.DescribeAppMenuItem();
        new partnerSoapSforceAPI.ProcessSubmitRequest();
        new partnerSoapSforceAPI.describeNounsResponse_element();
        new partnerSoapSforceAPI.DeleteByExampleResult();
        new partnerSoapSforceAPI.SoqlConditionGroup();
        new partnerSoapSforceAPI.describeSObjectListViews_element();
        new partnerSoapSforceAPI.DescribeLayout();
        new partnerSoapSforceAPI.ListViewOrderBy();
        new partnerSoapSforceAPI.SearchResultsMetadata();
        new partnerSoapSforceAPI.resetPassword_element();
        new partnerSoapSforceAPI.describeSObject_element();
        new partnerSoapSforceAPI.getDeleted_element();
        new partnerSoapSforceAPI.RenderEmailTemplateResult();
        new partnerSoapSforceAPI.describeSoqlListViews_element();
        new partnerSoapSforceAPI.invalidateSessions_element();
        new partnerSoapSforceAPI.describeVisualForce_element();
        new partnerSoapSforceAPI.FieldDiff();
        new partnerSoapSforceAPI.DescribeSoqlListViewsRequest();
        new partnerSoapSforceAPI.describeAppMenu_element();
        new partnerSoapSforceAPI.describeQuickActionsForRecordType_element();
        new partnerSoapSforceAPI.describeDataCategoryGroupsResponse_element();
        new partnerSoapSforceAPI.SessionHeader_element();
        new partnerSoapSforceAPI.retrieveMassQuickActionTemplatesResponse_element();
        new partnerSoapSforceAPI.ResetPasswordResult();
        new partnerSoapSforceAPI.DescribePathAssistantStep();
        new partnerSoapSforceAPI.setPassword_element();
        new partnerSoapSforceAPI.DescribeQuickActionListResult();
        new partnerSoapSforceAPI.GetUpdatedResult();
        new partnerSoapSforceAPI.ExecuteListViewResult();
        new partnerSoapSforceAPI.merge_element();
        new partnerSoapSforceAPI.RelatedListSort();
        new partnerSoapSforceAPI.search_element();
        new partnerSoapSforceAPI.DuplicateError();
        new partnerSoapSforceAPI.describeTabsResponse_element();
        new partnerSoapSforceAPI.SendEmailResult();
        new partnerSoapSforceAPI.MruHeader_element();
        new partnerSoapSforceAPI.createResponse_element();
        new partnerSoapSforceAPI.describeVisualForceResponse_element();
        new partnerSoapSforceAPI.logout_element();
        new partnerSoapSforceAPI.GetServerTimestampResult();
        new partnerSoapSforceAPI.retrieveQuickActionTemplatesResponse_element();
        new partnerSoapSforceAPI.QueryResult();
        new partnerSoapSforceAPI.delete_element();
        new partnerSoapSforceAPI.DescribeSoqlListViewResult();
        new partnerSoapSforceAPI.GetDeletedResult();
        new partnerSoapSforceAPI.DescribeNounResult();
        new partnerSoapSforceAPI.EntitySpellCorrectionMetadata();
        new partnerSoapSforceAPI.queryMore_element();
        new partnerSoapSforceAPI.SearchLayoutFieldsDisplayed();
        new partnerSoapSforceAPI.emptyRecycleBinResponse_element();
        new partnerSoapSforceAPI.PicklistForRecordType();
        new partnerSoapSforceAPI.DescribeLayoutFeedView();
        new partnerSoapSforceAPI.describeCompactLayoutsResponse_element();
        new partnerSoapSforceAPI.StringList();
        new partnerSoapSforceAPI.RecordTypeMapping();
        new partnerSoapSforceAPI.convertLead_element();
        new partnerSoapSforceAPI.AnalyticsCloudComponent();
        new partnerSoapSforceAPI.RelatedContent();
        new partnerSoapSforceAPI.SearchLayoutButton();
        new partnerSoapSforceAPI.PerformQuickActionRequest();
        new partnerSoapSforceAPI.DuplicateResult();
        new partnerSoapSforceAPI.getUserInfo_element();
        new partnerSoapSforceAPI.DescribeTab();
        new partnerSoapSforceAPI.LabelsSearchMetadata();
        new partnerSoapSforceAPI.describeQuickActionsForRecordTypeResponse_element();
        new partnerSoapSforceAPI.EntitySearchPromotionMetadata();
        new partnerSoapSforceAPI.process_element();
        new partnerSoapSforceAPI.DescribeTabSetResult();
        new partnerSoapSforceAPI.DescribeSearchableEntityResult();
        new partnerSoapSforceAPI.LoginResult();
        new partnerSoapSforceAPI.retrieveResponse_element();
        new partnerSoapSforceAPI.LimitInfo();
        new partnerSoapSforceAPI.EntityIntentQueryMetadata();
        new partnerSoapSforceAPI.describeSoftphoneLayout_element();
        new partnerSoapSforceAPI.renderStoredEmailTemplate_element();
        new partnerSoapSforceAPI.describeThemeResponse_element();
        new partnerSoapSforceAPI.performQuickActionsResponse_element();
        new partnerSoapSforceAPI.QuickActionTemplateResult();
        new partnerSoapSforceAPI.DescribeSoqlListView();
        new partnerSoapSforceAPI.upsertResponse_element();
        new partnerSoapSforceAPI.describeDataCategoryGroupStructuresResponse_element();
        new partnerSoapSforceAPI.retrieveResponse_element();
        new partnerSoapSforceAPI.convertLeadResponse_element();
        new partnerSoapSforceAPI.getDeletedResponse_element();
        new partnerSoapSforceAPI.describeSearchableEntities_element();
        new partnerSoapSforceAPI.RenderEmailTemplateRequest();
        new partnerSoapSforceAPI.describeCompactLayouts_element();
        new partnerSoapSforceAPI.getUserInfoResponse_element();
        new partnerSoapSforceAPI.describeKnowledgeSettingsResponse_element();
        new partnerSoapSforceAPI.findDuplicatesByIds_element();
        new partnerSoapSforceAPI.renderEmailTemplateResponse_element();
        new partnerSoapSforceAPI.queryAll_element();
        new partnerSoapSforceAPI.SearchRecordMetadata();
        new partnerSoapSforceAPI.executeListViewResponse_element();
        new partnerSoapSforceAPI.RecordTypesSupported();
        new partnerSoapSforceAPI.NamedLayoutInfo();
        new partnerSoapSforceAPI.describeAllTabs_element();
        new partnerSoapSforceAPI.retrieveMassQuickActionTemplates_element();
        new partnerSoapSforceAPI.PackageVersionHeader_element();
        new partnerSoapSforceAPI.DescribeSoftphoneLayoutSection();
        new partnerSoapSforceAPI.performQuickActions_element();
        new partnerSoapSforceAPI.NamedLayoutInfo();
        new partnerSoapSforceAPI.getUpdated_element();
        new partnerSoapSforceAPI.DisableFeedTrackingHeader_element();
        new partnerSoapSforceAPI.DescribeLayoutFeedFilter();
        new partnerSoapSforceAPI.describeSearchableEntitiesResponse_element();
        new partnerSoapSforceAPI.EntitySearchMetadata();
        new partnerSoapSforceAPI.DescribeLayoutButton();
        new partnerSoapSforceAPI.DescribeGlobalSObjectResult();
        new partnerSoapSforceAPI.DescribeSoftphoneLayoutItem();
        new partnerSoapSforceAPI.ProcessRequest();
        new partnerSoapSforceAPI.NameObjectValuePair();
        new partnerSoapSforceAPI.DescribeLayoutButton();
        new partnerSoapSforceAPI.DescribeGlobalSObjectResult();
        new partnerSoapSforceAPI.DescribeSoftphoneLayoutItem();
        new partnerSoapSforceAPI.DescribePathAssistantsResult();
        new partnerSoapSforceAPI.NameObjectValuePair();
        new partnerSoapSforceAPI.ListViewRecordColumn();
        new partnerSoapSforceAPI.AssignmentRuleHeader_element();
        new partnerSoapSforceAPI.describeQuickActions_element();
        new partnerSoapSforceAPI.describeAvailableQuickActions_element();
        new partnerSoapSforceAPI.SoqlCondition();
        new partnerSoapSforceAPI.DescribeApprovalLayout();
        new partnerSoapSforceAPI.describeTabs_element();
        new partnerSoapSforceAPI.SearchLayoutButtonsDisplayed();
        new partnerSoapSforceAPI.SendEmailError();
        new partnerSoapSforceAPI.VisualforcePage();
        new partnerSoapSforceAPI.ProcessWorkitemRequest();
        new partnerSoapSforceAPI.describeSearchScopeOrderResponse_element();
        new partnerSoapSforceAPI.describeTheme_element();
        new partnerSoapSforceAPI.RelationshipReferenceTo();
        new partnerSoapSforceAPI.NameValuePair();
        new partnerSoapSforceAPI.describeSoqlListViewsResponse_element();
        new partnerSoapSforceAPI.OwnerChangeOption();
        new partnerSoapSforceAPI.FieldComponent();
        new partnerSoapSforceAPI.DescribeThemeResult();
        new partnerSoapSforceAPI.DescribeLayoutRow();
        new partnerSoapSforceAPI.DescribeSoftphoneLayoutCallType();
        new partnerSoapSforceAPI.Error();
        new partnerSoapSforceAPI.ScopeInfo();
        new partnerSoapSforceAPI.RecordTypeCompactLayoutMapping();
        new partnerSoapSforceAPI.CustomLinkComponent();
        new partnerSoapSforceAPI.DescribeGlobalTheme();
        new partnerSoapSforceAPI.SoqlWhereCondition();
        new partnerSoapSforceAPI.PerformQuickActionResult();
        new partnerSoapSforceAPI.KnowledgeLanguageItem();
        new partnerSoapSforceAPI.describePathAssistants_element();
        new partnerSoapSforceAPI.logoutResponse_element();
        new partnerSoapSforceAPI.getUpdatedResponse_element();
        new partnerSoapSforceAPI.ListViewColumn();
        new partnerSoapSforceAPI.SoqlNotCondition();
        new partnerSoapSforceAPI.UndeleteResult();
        new partnerSoapSforceAPI.describeSObjectResponse_element();
        new partnerSoapSforceAPI.DescribeLayoutComponent();
        new partnerSoapSforceAPI.FieldLayoutComponent();
        new partnerSoapSforceAPI.ListViewRecord();
        new partnerSoapSforceAPI.queryAllResponse_element();
        new partnerSoapSforceAPI.describeGlobalTheme_element();
        new partnerSoapSforceAPI.Soap();
        Test.stopTest();
    }
}