public class BN_ThankYouController {
    public Id objId { get; set; }
    public String objType { get; set; }
    public String message { get; set; }

    public BN_ThankYouController() {
        objId = ApexPages.currentPage().getParameters().get('id');
        message = 'Thank You! Your request has been made and being processed.';
        if (objId != null) {
            objType = objId.getSObjectType().getDescribe().getName();

            if (objType.equals('Quote')) {
                message = 'The activation is successful!';
            }
        }
    }
}