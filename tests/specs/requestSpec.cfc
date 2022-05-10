component extends=testbox.system.BaseSpec {

  function run() {
    describe("The API requests", function() {
      var config = {
        apiVersion     : "latest",
        defaultCurrency: "usd"
      };
      var access_token = "fake_access_token";
      var page_id      = 12345;
      var fblgf        = new facebookleadgenforms(access_token, page_id);
      prepareMock(fblgf);
      fblgf.$(
        "makeHttpRequest",
        {
          responseHeader: {
            "Content-Type": "application/json",
            "Request-Id"  : ""
          },
          statuscode : "200 OK",
          filecontent: "{}"
        }
      );

      afterEach(function() {
        fblgf.$reset();
      });

      it("include the access_token as a query param", function() {
        var res         = fblgf.listByPage(0);
        var httpRequest = fblgf.$callLog().makeHttpRequest[1];
        expect(httpRequest.queryParams.access_token).toBe(access_token);
      });
      it("lists leadgen form fields", function() {
        var res = fblgf.listAvailableFields();
        expect(res.len()).toBe(22);
      });
      it("lists leadgen forms", function() {
        var res         = fblgf.listByPage();
        var httpRequest = fblgf.$callLog().makeHttpRequest[1];
        expect(httpRequest.path).toBe("https://graph.facebook.com/v13.0/#page_id#/leadgen_forms");
      });
      it("lists leadgen forms with all fields", function() {
        var res         = fblgf.listByPage("all");
        var httpRequest = fblgf.$callLog().makeHttpRequest[1];
        expect(httpRequest.path).toBe("https://graph.facebook.com/v13.0/#page_id#/leadgen_forms");
        expect(httpRequest.queryParams.fields).toBe(fblgf.listAvailableFields().toList());
      });
      it("creates leadgen forms", function() {
        var context_card = {
          "title"  : "Get in Touch",
          "content": ["First line", "Second item"],
          "style"  : "LIST_STYLE"
        };
        var custom_disclaimer = {
          "title": "Terms and Conditions",
          "body" : {
            "text"        : "I am a custom disclaimer.",
            "url_entities": [
              {
                "offset": 15,
                "length": 10,
                "url"   : "https://www.disclaimer.com/"
              }
            ]
          }
        };
        var follow_up_action_url = "https://www.test.com/followup";
        var privacy_policy       = {
          "url"      : "https://www.consumerfinance.gov/compliance/compliance-resources/other-applicable-requirements/privacy-notices/",
          "link_text": "View this test Privacy Notice"
        };
        var privacy_policy_url            = "https://www.privacypolicy.here";
        var question_page_custom_headline = "Look at me!";
        var questions                     = [
          {
            "key"  : "any_details_you'd_like_to_provide?",
            "label": "Any Details You'd Like to Provide?",
            "type" : "CUSTOM"
          },
          {
            "key" : "first_name",
            "type": "FIRST_NAME"
          }
        ];
        var thank_you_page = {
          "title"           : "Thanks, you are all set.",
          "body"            : "You can do something good if you like.",
          "button_text"     : "Do something good",
          "enable_messenger": false,
          "button_type"     : "VIEW_WEBSITE",
          "website_url"     : "https://www.heartsofjoyinternational.com/"
        };
        var tracking_parameters = {
          "utm_content": 12345,
          "secret_guid": "16737FB9-9233-414C-89A7-438D991353E5"
        };
        var leadform = new helpers.leadform()
          .name("TEST form")
          .allowOrganicLeads()
          .doNotblockDisplayForNonTargeted()
          .contextCard(context_card)
          .customDisclaimer(custom_disclaimer)
          .followUpActionUrl(follow_up_action_url)
          .optimizeForLeads()
          .privacyPolicy(privacy_policy)
          .privacyPolicyUrl(privacy_policy_url)
          .customHeadline(question_page_custom_headline)
          .questions(questions)
          .thankYouPage(thank_you_page)
          .trackingParameters(tracking_parameters);
        var res         = fblgf.create(leadform);
        var httpRequest = fblgf.$callLog().makeHttpRequest[1];
        expect(httpRequest.path).toBe("https://graph.facebook.com/v13.0/#page_id#/leadgen_forms");
        var payload = httpRequest.payload;
        expect(payload).toBeStruct();
        expect(payload.allow_organic_lead).toBeTrue();
        expect(payload.block_display_for_non_targeted_viewer).toBeFalse();
        expect(payload.is_optimized_for_quality).toBeFalse();
        expect(payload.context_card).toBe(context_card);
        expect(payload.custom_disclaimer).toBe(custom_disclaimer);
        expect(payload.follow_up_action_url).toBe(follow_up_action_url);
        expect(payload.privacy_policy).toBe(privacy_policy);
        expect(payload.privacy_policy_url).toBe(privacy_policy_url);
        expect(payload.question_page_custom_headline).toBe(question_page_custom_headline);
        expect(payload.questions).toBe(questions);
        expect(payload.thank_you_page).toBe(thank_you_page);
        expect(payload.tracking_parameters).toBe(tracking_parameters);
      });
      it("archives forms", function() {
        var form_id     = 12345;
        var res         = fblgf.archive(form_id);
        var httpRequest = fblgf.$callLog().makeHttpRequest[1];
        expect(httpRequest.path).toBe("https://graph.facebook.com/v13.0/#form_id#");
        expect(httpRequest.httpMethod).toBe("POST");
        expect(httpRequest.payload.status).toBe("ARCHIVED");
      });
    });
  }

}
