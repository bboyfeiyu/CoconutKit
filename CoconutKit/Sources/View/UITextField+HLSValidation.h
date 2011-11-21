//
//  UITextField+HLSValidation.h
//  CoconutKit
//
//  Created by Samuel Défago on 28.10.11.
//  Copyright (c) 2011 Hortis. All rights reserved.
//

// Forward declarations
@protocol HLSTextFieldValidationDelegate;

/**
 * This class extension allows UITextField objects to be bound to model object fields when HLSValidation has been
 * enabled on NSManagedObject (for more information, please refer to NSManagedObject+HLSValidation.h first).
 
 * Binding eliminates the need to write code to synchronize a model object field and the text field used to display
 * and edit its value. Moreover, if a -check<fieldName>:error: has been defined for the managed object field, it
 * will automatically be called, either when exiting input mode or when the field value changes (depending on a
 * setting).
 *
 * When a text field gets bound, its value is set to the current value of the model object field. If the model
 * object field value changes after it has been bound, the text field gets updated (and validated) accordingly.
 * Conversely, when a text field has been edited (i.e. when exiting input mode), the model object field value
 * is automatically updated. An optional NSFormatter can be attached to the field to automatically format / parse
 * the value displayed by the text field. An optional validation delegate receives validation events.
 *
 * Otherwise, a bound text field behaves exactly as a normal text field. In particular, some delegate must implement
 * UITextFieldDelegate protocol methods to dismiss the keyboard when appropriate.
 *
 * Categories on UIView and UIViewController are also provided. They can be used to trigger validation for all
 * text fields on a form, which is useful when implementing an OK button validating the whole form.
 *
 * To use any of the methods in the HLSValidation text field category, HLSValidation must be enabled on NSManagedObject
 * first. This is achieved by calling the HLSEnableNSManagedObjectValidation macro at global scope.
 */
@interface UITextField (HLSValidation)

/**
 * Bind the text field to a specific field of a managed object. Optional formatter and validation delegate can
 * be provided
 */
- (void)bindToManagedObject:(NSManagedObject *)managedObject
                  fieldName:(NSString *)fieldName
                  formatter:(NSFormatter *)formatter
         validationDelegate:(id<HLSTextFieldValidationDelegate>)validationDelegate;

/**
 * Remove any binding which might have been defined for the text field
 */
- (void)unbind;

/**
 * Return the binding settings
 */
- (NSManagedObject *)boundManagedObject;
- (NSString *)boundFieldName;
- (id<HLSTextFieldValidationDelegate>)validationDelegate;

/**
 * If checking on change is enabled (it is disabled by default), then validation is performed each time the
 * content of the text field changes. Otherwise validation is only performed when exiting edit mode for this
 * field, or when the text field loses focus
 */
- (BOOL)isCheckingOnChange;
- (void)setCheckingOnChange:(BOOL)checkingOnChange;

@end

/**
 * Protocol to be implemented by validation delegates
 */
@protocol HLSTextFieldValidationDelegate <NSObject>

@optional

/**
 * This method is called when validation has been successfully performed
 */
- (void)textFieldDidPassValidation:(UITextField *)textField;

/**
 * This method is called when validation was not successful. The error which is received can be used to
 * display further information to the user
 */
- (void)textField:(UITextField *)textField didFailValidationWithError:(NSError *)error;

@end

@interface UIView (HLSValidation)

/**
 * Fina all bound text fields on a view and performs validation for each of them (the method does not
 * stop if an error is encountered, validation is triggered for all fields). If all fields are valid,
 * the model object is updated and the method returns YES. Otherwise the model object is not updated
 * and the method returns NO
 */
- (BOOL)checkAndSynchronizeTextFields;

@end

@interface UIViewController (HLSValidation)

/**
 * Same as -[UIView checkAndSynchronizeTextFields], but applied on a view controller's view
 */
- (BOOL)checkAndSynchronizeTextFields;

@end
