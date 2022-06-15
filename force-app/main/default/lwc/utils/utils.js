import Date from './date'
import Pubsub from './pubsub';
import { ShowToastEvent }   from 'lightning/platformShowToastEvent';
import { NavigationMixin }  from 'lightning/navigation';
import { label }            from 'c/labelUtils';

// import Notification from 'c/wfc_utils_notification';

export default class Utils {
    static Date = Date;
    static Pubsub = Pubsub;

    static handleError = (error) => {
        Notification.show(
            'Error',
            (error && ((error.body && error.body.message) || error.message)) || error,
            Notification.TYPE.ERROR
        );
    };
}


const showSuccessToast = (component, message, title = label.PBO_MessageTitle_Success) => {
    showToast(component, 'success', title, message);
}

const showFailToast = (component, message, title = label.PBO_MessageTitle_Fail) => {
    showToast(component, 'error', title, message);
}

const navigateToRecordPage = (component, recordId) => {
    const actionName = 'view';
    component[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: { recordId, actionName },
    });
}

const parseErrors = (errors) => {
    const messages = [];

    if (errors) {
        errors = [].concat(errors);
        errors.forEach((error) => {
            if (error.pageErrors) {
                error.pageErrors.forEach((pageError) =>
                    messages.push(pageError.message));
            }

            if (error.fieldErrors) {
                for (let fieldName in error.fieldErrors) {
                    error.fieldErrors[fieldName].forEach((fieldError) =>
                        messages.push(fieldError.message));
                }
            }

            if (error.message) {
                messages.push(error.message);
            }
        });
    }

    return messages.length ? messages.join('\n') : "Unknown Error";
}

export {
    showSuccessToast,
    showFailToast,
    navigateToRecordPage,
    parseErrors
}

//---------------------------------------------------------------------------------
// private methods
const showToast = (component, variant, title, message, mode = 'dismissable') => {
    const e = new ShowToastEvent({ title, message, variant, mode });
    component.dispatchEvent(e);
}