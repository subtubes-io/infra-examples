function handler(event) {
    var request = event.request;
    var host = request.headers.host.value;
    var customDomain = '${fqdn}';
    
    if (host.endsWith('.cloudfront.net')) {
        var redirectUrl = 'https://' + customDomain;
        var response = {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                'location': { 'value': redirectUrl }
            }
        };
        return response;
    }
    return request;
}