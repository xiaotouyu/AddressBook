//
//  ViewController.m
//  AddressBook
//
//  Created by dashuios126 on 16/12/29.
//  Copyright © 2016年 dashuios126. All rights reserved.
//

#import "ViewController.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>


@interface ViewController ()<CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) NSMutableArray *nameList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    if (self.nameList.count > 0) {
        self.nameLabel.text = self.nameList.firstObject;
    }
}

- (NSMutableArray *)nameList{

    if (_nameList == nil) {
        _nameList = [NSMutableArray array];
    }
    return _nameList;
}

- (IBAction)jumpToAddressBook:(UIButton *)sender {
    UIApplication *appliction = [UIApplication sharedApplication];

    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
//    [appliction openURL:url];

    if ([appliction canOpenURL:url]) {
        if ([appliction respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [appliction openURL:url options:@{} completionHandler:nil];

        }else{
            [appliction openURL:url];
        }
    }




    
    //Contacts 实现 (iOS 9.0 之后)
//    CNContactPickerViewController *contactVC = [[CNContactPickerViewController alloc]init];
//    contactVC.delegate = self;
//    [self presentViewController:contactVC animated:YES completion:nil];

    //AddressBook 实现 (iOS 9.0 之前,9.0之后废弃)
//    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
//    nav.peoplePickerDelegate = self;
//    CGFloat device = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if(device > 8.0){
//        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
//    }
//    [self presentViewController:nav animated:YES completion:nil];
}
//ios 8.0

// 必须设置 nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];否则会在进入到详情界面直接返回无法操作
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{

    NSLog(@"%@",person);

    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

// 实现此方法即可
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{

    NSLog(@"identifier: %d",identifier);
    //获取phone
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);

    long index = ABMultiValueGetIndexForIdentifier(phone, identifier);
    //根据特定的identifier 获取到特定的phone
    NSString *phoneNo = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, index));
    NSLog(@"1------%@",phoneNo);
    if ([phoneNo hasPrefix:@"+"]) {
        phoneNo = [phoneNo substringFromIndex:3];
        NSLog(@"2------%@",phoneNo);
    }
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"3------%@",phoneNo);
    if (phone) {
        
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }

}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{

    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
//ios 7.0
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//{
//    return YES;
//}
//
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
//{
//    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
//    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
//    if ([phoneNO hasPrefix:@"+"]) {
//        phoneNO = [phoneNO substringFromIndex:3];
//    }
//
//    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"%@", phoneNO);
//    if (phone ) {
////        phoneNum = phoneNO;
////        [self.tableView reloadData];
//        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//        return NO;
//    }
//    return YES;
//}


#pragma mark CNContactPickerDelegate
#pragma mark 选取一个联系人
//选中联系人直接返回,不会进入到详情界面
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
//
//    NSLog(@"%s \n %@",__func__,contact);
//    NSArray *phoneNumbers = contact.phoneNumbers;
//    [phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"CNLabeledValue %@",obj.value);
//        CNPhoneNumber *phoneNumber = obj.value;
//        NSLog(@"phoneNumber: %@ givenName:%@",phoneNumber.stringValue,contact.givenName);
//    }];
//
//}
//#pragma mark 选取多个联系人
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts{
//    NSLog(@"%s \n %@",__func__,contacts);
//
//    [contacts enumerateObjectsUsingBlock:^(CNContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSArray *phoneNumbers = contact.phoneNumbers;
//        [phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"CNLabeledValue %@",obj.value);
//            CNPhoneNumber *phoneNumber = obj.value;
//            NSLog(@"phoneNumber: %@ familyName:%@ givenName:%@",phoneNumber.stringValue,contact.familyName,contact.givenName);
//            NSString *name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
//            [self.nameList addObject:name];
//        }];
//    }];
//}

//  选中联系人不会直接返回,会进入到详情界面 contactProperty.contact.givenName 这个属性是名 contactProperty.contact.familyName 这个属性是姓
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{

    NSLog(@" contactProperty %@",contactProperty);
    //contactProperty.contact.phoneNumbers 这个属性表示此联系人下的所有电话号码
    NSArray *phoneNumbers = contactProperty.contact.phoneNumbers;
    [phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"CNLabeledValue %@",obj.value);
        CNPhoneNumber *phoneNumber = obj.value;
        NSLog(@"phoneNumber: %@ givenName:%@",phoneNumber.stringValue,contactProperty.contact.givenName);
    }];
}

//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty *> *)contactProperties{
//
//    NSLog(@"contactProperties %@",contactProperties);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
