/**
* Facebook Leadgen Forms - CFML
* Copyright 2022  Matthew J. Clemente, John Berquist
* Licensed under MIT (https://mit-license.org)
*/
component displayname="FBLGF CFML" {

  variables._fblgfcfml_version = "1.0.0";

  public any function init(
    string access_token = "",
    string page_id      = "",
    string baseUrl      = "https://graph.facebook.com",
    string apiVersion   = "v13.0",
    boolean includeRaw  = false,
    numeric httpTimeout = 50
  ) {
    structAppend(variables, arguments);

    // map sensitive args to env variables or java system props
    var secrets = {
      "access_token": "FACEBOOKLEADGENFORMS_ACCESS_TOKEN",
      "page_id"     : "FACEBOOKLEADGENFORMS_PAGE_ID"
    };
    var system = createObject("java", "java.lang.System");

    for( var key in secrets ){
      // arguments are top priority
      if( variables[key].len() ){
        continue;
      }

      // check environment variables
      var envValue = system.getenv(secrets[key]);
      if( !isNull(envValue) && envValue.len() ){
        variables[key] = envValue;
        continue;
      }

      // check java system properties
      var propValue = system.getProperty(secrets[key]);
      if( !isNull(propValue) && propValue.len() ){
        variables[key] = propValue;
      }
    }
    variables.available_form_fields = [
      "id",
      "name",
      "allow_organic_lead",
      "block_display_for_non_targeted_viewer",
      "context_card",
      "created_time",
      "expired_leads_count",
      "follow_up_action_text",
      "follow_up_action_url",
      "is_optimized_for_quality",
      "leads_count",
      "legal_content",
      "locale",
      "organic_leads_count",
      "page",
      "page_id",
      "privacy_policy_url",
      "question_page_custom_headline",
      "questions",
      "status",
      "thank_you_page",
      "tracking_parameters"
    ];
    variables.fileFields = [];
    return this;
  }

  /**
  * @docs https://developers.facebook.com/docs/graph-api/reference/lead-gen-data/
  * @hint Lists all available fields for Lead Gen Data
  */
  public array function listAvailableFields() {
    return variables.available_form_fields;
  }

  /**
  * @docs https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#readform
  * @hint Retrieves a list of all forms available on a Page
  * @fields returns all available fields if set to `all`. Otherwise it can be left blank, or provided a list/array of the fields required.
  */
  public struct function listByPage(any fields) {
    var params = {};
    if( !isNull(arguments.fields) ){
      if( isSimpleValue(arguments.fields) && arguments.fields == "all" ){
        params["fields"] = variables.available_form_fields.toList();
      } else {
        params["fields"] = isArray(arguments.fields) ? arguments.fields.toList() : fields;
      }
    }
    return apiCall("GET", "/#variables.page_id#/leadgen_forms", params);
  }

  /**
  * @docs https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#lead_form
  * @hint Create a lead form with questions you can display in lead ads
  * @leadform expects an instance of the `helpers.leadform` component, but you can construct the struct yourself if you prefer.
  */
  public struct function create(required any leadform) {
    var payload = isObject(arguments.leadform)
     ? arguments.leadform.build()
     : arguments.leadform;

    return apiCall("POST", "/#variables.page_id#/leadgen_forms", {}, payload);
  }

  /**
  * @docs https://developers.facebook.com/docs/marketing-api/guides/lead-ads/create#archiveform
  * @hint Archive a lead form
  */
  public struct function archive(required numeric form_id) {
    var payload = {"status": "ARCHIVED"}
    return apiCall("POST", "/#arguments.form_id#", {}, payload);
  }

  // PRIVATE FUNCTIONS
  private struct function apiCall(
    required string httpMethod,
    required string path,
    struct queryParams = {},
    any payload        = "",
    struct headers     = {}
  ) {
    var fullApiPath = variables.baseUrl & path;
    var fullApiPath = variables.baseUrl & "/" & variables.apiVersion & path;

    var requestHeaders = getBaseHttpHeaders();
    requestHeaders.append(headers, true);

    queryParams["access_token"] = variables.access_token;

    var requestStart = getTickCount();
    var apiResponse  = makeHttpRequest(
      httpMethod  = httpMethod,
      path        = fullApiPath,
      queryParams = queryParams,
      headers     = requestHeaders,
      payload     = payload
    );

    var result = {
      "responseTime": getTickCount() - requestStart,
      "statusCode"  : listFirst(apiResponse.statuscode, " "),
      "statusText"  : listRest(apiResponse.statuscode, " "),
      "headers"     : apiResponse.responseheader
    };

    var parsedFileContent = {};

    // Handle response based on mimetype
    var mimeType = apiResponse.mimetype ?: requestHeaders["Content-Type"];

    if( mimeType == "application/json" && isJSON(apiResponse.fileContent) ){
      parsedFileContent = deserializeJSON(apiResponse.fileContent);
    } else if( mimeType.listLast("/") == "xml" && isXML(apiResponse.fileContent) ){
      parsedFileContent = xmlToStruct(apiResponse.fileContent);
    } else {
      parsedFileContent = apiResponse.fileContent;
    }

    // can be customized by API integration for how errors are returned
    // if ( result.statusCode >= 400 ) {}

    // stored in data, because some responses are arrays and others are structs
    result["data"] = parsedFileContent;

    if( variables.includeRaw ){
      result["raw"] = {
        "method"  : uCase(httpMethod),
        "path"    : fullApiPath,
        "params"  : parseQueryParams(queryParams),
        "payload" : payload,
        "response": apiResponse.fileContent
      };
    }

    return result;
  }

  private struct function getBaseHttpHeaders() {
    return {
      "Accept"      : "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "User-Agent"  : "Facebook Leadgen Forms - CFML/#variables._fblgfcfml_version# (ColdFusion)"
    };
  }

  private any function makeHttpRequest(
    required string httpMethod,
    required string path,
    struct queryParams = {},
    struct headers     = {},
    any payload        = ""
  ) {
    var result = "";

    var fullPath = path & (
      !queryParams.isEmpty()
       ? ("?" & parseQueryParams(queryParams, false))
       : ""
    );

    cfhttp(url = fullPath, method = httpMethod, result = "result", timeout = variables.httpTimeout) {
      if( isJsonPayload(headers) ){
        var requestPayload = parseBody(payload);
        if( isJSON(requestPayload) ){
          cfhttpparam(type = "body", value = requestPayload);
        }
      } else if( isFormPayload(headers) ){
        // at one point this header needed to be deleted, because Content-Type was automatically being added by cfhttppparam, but it *seems* this is not an issue any more, and when Lucee is allowed the add the header, it appends "; charset=UTF-8", which can cause further issues
        // headers.delete("Content-Type");

        for( var param in payload ){
          if( !variables.fileFields.contains(param) ){
            cfhttpparam(
              type  = "formfield",
              name  = param,
              value = isSimpleValue(payload[param]) ? payload[param] : serializeJSON(payload[param])
            );
          } else {
            cfhttpparam(type = "file", name = param, file = payload[param]);
          }
        }
      }

      // handled last, to account for possible Content-Type header correction for forms
      var requestHeaders = parseHeaders(headers);
      for( var header in requestHeaders ){
        cfhttpparam(type = "header", name = header.name, value = header.value);
      }
    }
    return result;
  }

  /**
  * @hint convert the headers from a struct to an array
  */
  private array function parseHeaders(required struct headers) {
    var sortedKeyArray = headers.keyArray();
    sortedKeyArray.sort("textnocase");
    var processedHeaders = sortedKeyArray.map(function( key ) {
      return {name: key, value: trim(headers[key])};
    });
    return processedHeaders;
  }

  /**
  * @hint converts the queryparam struct to a string, with optional encoding and the possibility for empty values being pass through as well
  */
  private string function parseQueryParams(
    required struct queryParams,
    boolean encodeQueryParams  = true,
    boolean includeEmptyValues = true
  ) {
    var sortedKeyArray = queryParams.keyArray();
    sortedKeyArray.sort("text");

    var queryString = sortedKeyArray.reduce(function( queryString, queryParamKey ) {
      var encodedKey = encodeQueryParams
       ? encodeUrl(queryParamKey)
       : queryParamKey;
      if( !isArray(queryParams[queryParamKey]) ){
        var encodedValue = encodeQueryParams && len(queryParams[queryParamKey])
         ? encodeUrl(queryParams[queryParamKey])
         : queryParams[queryParamKey];
      } else {
        var encodedValue = encodeQueryParams && arrayLen(queryParams[queryParamKey])
         ? encodeUrl(serializeJSON(queryParams[queryParamKey]))
         : queryParams[queryParamKey].toList();
      }
      return queryString.listAppend(
        encodedKey & (includeEmptyValues || len(encodedValue) ? ("=" & encodedValue) : ""),
        "&"
      );
    }, "");

    return queryString.len() ? queryString : "";
  }

  private string function parseBody(required any body) {
    if( isStruct(body) || isArray(body) ){
      return serializeJSON(body);
    } else if( isJSON(body) ){
      return body;
    } else {
      return "";
    }
  }

  private string function encodeUrl(required string str, boolean encodeSlash = true) {
    var result = replaceList(urlEncodedFormat(str, "utf-8"), "%2D,%2E,%5F,%7E", "-,.,_,~");
    if( !encodeSlash ){
      result = replace(result, "%2F", "/", "all");
    }
    return result;
  }

  /**
  * @hint helper to determine if body should be sent as JSON
  */
  private boolean function isJsonPayload(required struct headers) {
    return headers["Content-Type"] == "application/json";
  }

  /**
  * @hint helper to determine if body should be sent as form params
  */
  private boolean function isFormPayload(required struct headers) {
    return arrayContains(["application/x-www-form-urlencoded", "multipart/form-data"], headers["Content-Type"]);
  }

  /**
  *
  * Based on an (old) blog post and UDF from Raymond Camden
  * https://www.raymondcamden.com/2012/01/04/Converting-XML-to-JSON-My-exploration-into-madness/
  *
  */
  private struct function xmlToStruct(required any x) {
    if( isSimpleValue(x) && isXML(x) ){
      x = xmlParse(x);
    }

    var s = {};

    if( xmlGetNodeType(x) == "DOCUMENT_NODE" ){
      s[structKeyList(x)] = xmlToStruct(x[structKeyList(x)]);
    }

    if( structKeyExists(x, "xmlAttributes") && !structIsEmpty(x.xmlAttributes) ){
      s.attributes = {};
      for( var item in x.xmlAttributes ){
        s.attributes[item] = x.xmlAttributes[item];
      }
    }

    if( structKeyExists(x, "xmlText") && x.xmlText.trim().len() ){
      s.value = x.xmlText;
    }

    if( structKeyExists(x, "xmlChildren") ){
      for( var xmlChild in x.xmlChildren ){
        if( structKeyExists(s, xmlChild.xmlname) ){
          if( !isArray(s[xmlChild.xmlname]) ){
            var temp            = s[xmlChild.xmlname];
            s[xmlChild.xmlname] = [temp];
          }

          arrayAppend(s[xmlChild.xmlname], xmlToStruct(xmlChild));
        } else {
          if( structKeyExists(xmlChild, "xmlChildren") && arrayLen(xmlChild.xmlChildren) ){
            s[xmlChild.xmlName] = xmlToStruct(xmlChild);
          } else if( structKeyExists(xmlChild, "xmlAttributes") && !structIsEmpty(xmlChild.xmlAttributes) ){
            s[xmlChild.xmlName] = xmlToStruct(xmlChild);
          } else {
            s[xmlChild.xmlName] = xmlChild.xmlText;
          }
        }
      }
    }

    return s;
  }

}
