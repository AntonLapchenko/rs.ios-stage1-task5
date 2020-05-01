#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

//MARK: - Constant
#define countryCode8 [NSArray arrayWithObjects: @"MD", @"AM", @"TM", nil]
#define countryCode9 [NSArray arrayWithObjects: @"BY", @"UA", @"TJ", @"AZ", @"KG", @"UZ", nil]
#define countryCode10 [NSArray arrayWithObjects: @"RU", @"KZ", nil]

NSString *const formatterPhone8 =  @"+xxx (xx) xxx-xxx";
NSString *const formatterPhone9 = @"+xxx (xx) xxx-xx-xx";
NSString *const formatterPhone10 = @"+x (xxx) xxx-xx-xx";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSString *codeKey = [self codeKey:string];
    string = [self determinationOfTheCorrectLenght:string];
    string = [self formatter:string byCode:codeKey];
    string = [self addingAPlusToNonStandart:string byCode:codeKey];
    string = [self removePlusFromThe: string];
    return @{KeyPhoneNumber: string,
             KeyCountry: codeKey};
}

-(NSString *) determinationOfTheCorrectLenght:(NSString *)string {
    if ([string length] > 12 && [[string substringToIndex:1] isEqualToString:@"+"]) {
        return  [string substringToIndex:13];
    }
    if ([string length] > 12) {
       return   [string substringToIndex:12];
    }
    return string;
}
//MARK: - Logic for the plus
-(NSString *) removePlusFromThe:(NSString *)string {
    NSString *test = [NSString new];
    test = [string substringToIndex:2];
    if ([test isEqualToString:@"++"]) {
        return  [string substringFromIndex:1];
    }
    return string;
}

-(NSString *) addingAPlusToNonStandart:(NSString *)phoneNumber byCode: (NSString *)code {
    if ([code isEqualToString:@""])
        phoneNumber = [NSString stringWithFormat:@"+%@", phoneNumber];
    return phoneNumber;
}

//MARK: - PhoneNumber formatting
-(NSString *)formatter:(NSString *)phoneString byCode:(NSString *)code {
    for (NSString *item in countryCode9) {
        if ([code isEqualToString:item]){
           phoneString = [self numberFormatting:phoneString byModel:formatterPhone9];
        }
    }
    for (NSString *item in countryCode8) {
        if ([code isEqualToString:item]){
           phoneString = [self numberFormatting:phoneString byModel:formatterPhone8];
        }
    }
    for (NSString *item in countryCode10) {
        if ([code isEqualToString:item]){
           phoneString = [self numberFormatting:phoneString byModel:formatterPhone10];
        }
    }
    return phoneString;
}

-(NSString *)numberFormatting:(NSString *)string byModel:(NSString *)requiredFormat {
    NSString *formattindString = [requiredFormat mutableCopy];
    unichar item;
    
    for (NSInteger i = 0; i < [string length]; i++) {
        item = [string characterAtIndex:i];
        NSRange range = [formattindString rangeOfString:@"x"];
        if (NSNotFound != range.location) {
            NSString* charStr = [NSString stringWithCharacters:&item length:1];
            formattindString = [formattindString stringByReplacingCharactersInRange:range withString:charStr];
        }
    }
    NSString *result = [NSString new];
    [[NSScanner scannerWithString:formattindString] scanUpToString:@"x" intoString:&result];
    return [result stringByTrimmingCharactersInSet:[NSCharacterSet
                                                    characterSetWithCharactersInString:@"-() "]];
}
//MARK: - Country code key definnition
-(NSString*)codeKey:(NSString*)string {
    NSString *codeCountry = [NSString new];
    NSString *resultCodeKey = [NSString new];
    if ([string length] >= 3){
        codeCountry = [string substringToIndex:3];
        resultCodeKey = [self countryCode:codeCountry];
    }
    
    if ([resultCodeKey isEqualToString:@""] && [string length] >= 2) {
        codeCountry = [string substringToIndex:2];
        resultCodeKey = [self countryCode:codeCountry];
    }
    if ([resultCodeKey isEqualToString:@""]) {
        codeCountry = [string substringToIndex:1];
        resultCodeKey = [self countryCode:codeCountry];
    }
    return resultCodeKey;
}

//MARK: - Country code definnition
- (NSString*)countryCode:(NSString*)numbers {
    if ([numbers isEqualToString:@"7"])
    {
        return @"RU";
    }
    else if ([numbers isEqualToString:@"77"])
    {
        return @"KZ";
    }
    else if ([numbers isEqualToString:@"373"])
    {
        return @"MD";
    }
    else if ([numbers isEqualToString:@"374"])
    {
        return @"AM";
    }
    else if ([numbers isEqualToString:@"375"])
    {
        return @"BY";
    }
    else if ([numbers isEqualToString:@"380"])
    {
        return @"UA";
    }
    else if ([numbers isEqualToString:@"992"])
    {
        return @"TJ";
    }
    else if ([numbers isEqualToString:@"993"])
    {
        return @"TM";
    }
    else if ([numbers isEqualToString:@"994"])
    {
        return @"AZ";
    }
    else if ([numbers isEqualToString:@"996"])
    {
        return @"KG";
    }
    else if ([numbers isEqualToString:@"998"])
    {
        return @"UZ";
    }
    return @"";
}
@end
