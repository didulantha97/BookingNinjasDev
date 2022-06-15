import { LightningElement, wire, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getSingleVacancy from "@salesforce/apex/BN_VacancyController.getSingleVacancy";
import submitApplication from "@salesforce/apex/BN_VacancyController.submitApplication";
import CAREER_OBJECT from "@salesforce/schema/Career__c";

export default class VacancyApplicationForm extends LightningElement {
  @api vacancyId;
  @api thankyouPageUrl;
  @track careerRecord = CAREER_OBJECT;

  _vacancy;
  _errors;
  _validationError;
  loading = true;
  submitting = false;
  fullName = "";
  phone = "";
  email = "";
  linkedin = "";
  position = "";

  @wire(getSingleVacancy, { vacancyId: "$vacancyId" })
  retrievedVacancy({ data, error }) {
    this.loading = false;

    if (data) {
      this._vacancy = data;
      this.position = data.Name;
      this.careerRecord.Position__c = data.Name;
      this.careerRecord.RelatedVacancy__c = data.Id;
    }

    if (error) {
      this._errors = error;
    }
  }

  get vacancy() {
    if (this._errors) {
      return null;
    }

    return this._vacancy;
  }

  get processing() {
    return this.loading || this.submitting;
  }

  get hasSubmissionError() {
    return this._validationError != undefined && this._validationError != null;
  }

  @track isModalOpen = false;
  openModal() {
    // to open modal set isModalOpen tarck value as true
    this.isModalOpen = true;
  }
  closeModal() {
    // to close modal set isModalOpen tarck value as false
    this.isModalOpen = false;
  }
  submitDetails() {
    // to close modal set isModalOpen tarck value as false
    //Add your code to call apex method or do some processing
    this.isModalOpen = false;
  }

  handleFullNameChange = (event) => {
    this.careerRecord.Name__c = this.fullName = event.target.value;
  };

  handlePhoneChange = (event) => {
    this.careerRecord.Phone__c = this.phone = event.target.value;
  };

  handleEmailChange = (event) => {
    this.careerRecord.Email__c = this.email = event.target.value;
  };

  handleLinkedInChange = (event) => {
    this.careerRecord.Linkedin__c = this.linkedin = event.target.value;
  };

  handleSubmit = (event) => {
    this.submitting = true;

    submitApplication({ career: this.careerRecord })
      .then((res) => {
        return JSON.parse(res);
      })
      .then((res) => {
        this.submitting = false;

        if (res.Status == "success") {
          const evt = new ShowToastEvent({
            title: "Congratulations!",
            message:
              "Your application has been received. You'll hear from us soon.",
            variant: "success"
          });
          this.dispatchEvent(evt);

          setTimeout(() => {
            window.location.href =
              this.thankyouPageUrl || "/thank-you-for-your-interest";
          }, 3000);
        } else {
          this._validationError = `${res.Message}`;
        }
      })
      .catch((err) => {
        this.submitting = false;
        this._validationError = `${err.message}`;
      });
  };
}