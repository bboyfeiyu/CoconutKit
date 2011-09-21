//
//  PlaceholderDemoViewController.m
//  CoconutKit-demo
//
//  Created by Samuel Défago on 2/14/11.
//  Copyright 2011 Hortis. All rights reserved.
//

#import "PlaceholderDemoViewController.h"

#import "ContainerCustomizationViewController.h"
#import "FixedSizeViewController.h"
#import "HeavyViewController.h"
#import "LandscapeOnlyViewController.h"
#import "LifeCycleTestViewController.h"
#import "MemoryWarningTestCoverViewController.h"
#import "OrientationClonerViewController.h"
#import "PortraitOnlyViewController.h"
#import "StretchableViewController.h"

@interface PlaceholderDemoViewController ()

@property (nonatomic, retain) HeavyViewController *heavyViewController;

- (void)displayInsetViewController:(UIViewController *)viewController;

- (void)lifeCycleTestSampleButtonClicked:(id)sender;
- (void)stretchableSampleButtonClicked:(id)sender;
- (void)fixedSizeSampleButtonClicked:(id)sender;
- (void)heavySampleButtonClicked:(id)sender;
- (void)portraitOnlyButtonClicked:(id)sender;
- (void)landscapeOnlyButtonClicked:(id)sender;
- (void)removeButtonClicked:(id)sender;
- (void)hideWithModalButtonClicked:(id)sender;
- (void)orientationClonerButtonClicked:(id)sender;
- (void)containerCustomizationButtonClicked:(id)sender;
- (void)stretchingContentSwitchValueChanged:(id)sender;
- (void)forwardingPropertiesSwitchValueChanged:(id)sender;

@end

@implementation PlaceholderDemoViewController

#pragma mark Object creation and destruction

- (id)init
{
    if ((self = [super initWithNibName:[self className] bundle:nil])) {
        // Pre-load a view controller before display. Yep, this is possible!
        self.insetViewController = [[[LifeCycleTestViewController alloc] init] autorelease];
        self.stretchingContent = YES;
    }
    return self;
}

- (void)dealloc
{
    self.heavyViewController = nil;
    [super dealloc];
}

- (void)releaseViews
{
    [super releaseViews];
    
    // Free heavy view in cache
    self.heavyViewController.view = nil;
    
    self.lifecycleTestSampleButton = nil;
    self.stretchableSampleButton = nil;
    self.fixedSizeSampleButton = nil;
    self.heavySampleButton = nil;
    self.portraitOnlyButton = nil;
    self.landscapeOnlyButton = nil;
    self.orientationClonerButton = nil;
    self.containerCustomizationButton = nil;
    self.removeButton = nil;
    self.hideWithModalButton = nil;
    self.transitionLabel = nil;
    self.transitionPickerView = nil;
    self.stretchingContentLabel = nil;
    self.stretchingContentSwitch = nil;
    self.forwardingPropertiesLabel = nil;
    self.forwardingPropertiesSwitch = nil;
}

#pragma mark Accessors and mutators

@synthesize lifecycleTestSampleButton = m_lifecycleTestSampleButton;

@synthesize stretchableSampleButton = m_stretchableSampleButton;

@synthesize fixedSizeSampleButton = m_fixedSizeSampleButton;

@synthesize heavySampleButton = m_heavySampleButton;

@synthesize portraitOnlyButton = m_portraitOnlyButton;

@synthesize landscapeOnlyButton = m_landscapeOnlyButton;

@synthesize orientationClonerButton = m_orientationClonerButton;

@synthesize containerCustomizationButton = m_containerCustomizationButton;

@synthesize removeButton = m_removeButton;

@synthesize hideWithModalButton = m_hideWithModalButton;

@synthesize transitionLabel = m_transitionLabel;

@synthesize transitionPickerView = m_transitionPickerView;

@synthesize stretchingContentLabel = m_stretchingContentLabel;

@synthesize stretchingContentSwitch = m_stretchingContentSwitch;

@synthesize forwardingPropertiesLabel = m_forwardingPropertiesLabel;

@synthesize forwardingPropertiesSwitch = m_forwardingPropertiesSwitch;

@synthesize heavyViewController = m_heavyViewController;

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lifecycleTestSampleButton addTarget:self
                                       action:@selector(lifeCycleTestSampleButtonClicked:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    [self.stretchableSampleButton addTarget:self
                                     action:@selector(stretchableSampleButtonClicked:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [self.fixedSizeSampleButton addTarget:self
                                   action:@selector(fixedSizeSampleButtonClicked:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.heavySampleButton addTarget:self
                               action:@selector(heavySampleButtonClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [self.portraitOnlyButton addTarget:self
                                action:@selector(portraitOnlyButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.landscapeOnlyButton addTarget:self
                                 action:@selector(landscapeOnlyButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [self.removeButton addTarget:self
                          action:@selector(removeButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.orientationClonerButton setTitle:@"HLSOrientationCloner"
                                  forState:UIControlStateNormal];
    [self.orientationClonerButton addTarget:self
                                     action:@selector(orientationClonerButtonClicked:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerCustomizationButton addTarget:self
                                          action:@selector(containerCustomizationButtonClicked:)
                                forControlEvents:UIControlEventTouchUpInside];
    
    [self.hideWithModalButton addTarget:self
                                 action:@selector(hideWithModalButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    self.stretchingContentSwitch.on = self.stretchingContent;
    [self.stretchingContentSwitch addTarget:self
                                     action:@selector(stretchingContentSwitchValueChanged:)
                           forControlEvents:UIControlEventValueChanged];
    
    self.forwardingPropertiesSwitch.on = self.forwardingProperties;
    [self.forwardingPropertiesSwitch addTarget:self
                                        action:@selector(forwardingPropertiesSwitchValueChanged:)
                              forControlEvents:UIControlEventValueChanged];
    
    self.transitionPickerView.delegate = self;
    self.transitionPickerView.dataSource = self;
}

#pragma mark Displaying an inset view controller according to the user settings

- (void)displayInsetViewController:(UIViewController *)viewController
{
    NSUInteger pickedIndex = [self.transitionPickerView selectedRowInComponent:0];
    [self setInsetViewController:viewController withTransitionStyle:pickedIndex];
}

#pragma mark Event callbacks

- (void)lifeCycleTestSampleButtonClicked:(id)sender
{
    LifeCycleTestViewController *lifecycleTestViewController = [[[LifeCycleTestViewController alloc] init] autorelease];
    [self displayInsetViewController:lifecycleTestViewController];
}

- (void)stretchableSampleButtonClicked:(id)sender
{
    StretchableViewController *stretchableViewController = [[[StretchableViewController alloc] init] autorelease];
    [self displayInsetViewController:stretchableViewController];
}

- (void)fixedSizeSampleButtonClicked:(id)sender
{
    FixedSizeViewController *fixedSizeViewController = [[[FixedSizeViewController alloc] init] autorelease];
    [self displayInsetViewController:fixedSizeViewController];
}

- (void)heavySampleButtonClicked:(id)sender
{
    // Store a strong ref to an already built HeavyViewController; this way, this view controller is kept alive and does
    // not need to be recreated from scratch each time it is displayed as inset (lazy creation suffices). This proves 
    // that caching view controller's views is made possible by HLSPlaceholderViewController if needed
    if (! self.heavyViewController) {
        self.heavyViewController = [[[HeavyViewController alloc] init] autorelease];
    }
    [self displayInsetViewController:self.heavyViewController];
}

- (void)portraitOnlyButtonClicked:(id)sender
{
    PortraitOnlyViewController *portraitOnlyViewController = [[[PortraitOnlyViewController alloc] init] autorelease];
    [self displayInsetViewController:portraitOnlyViewController];
}

- (void)landscapeOnlyButtonClicked:(id)sender
{
    LandscapeOnlyViewController *landscapeOnlyViewController = [[[LandscapeOnlyViewController alloc] init] autorelease];
    [self displayInsetViewController:landscapeOnlyViewController];
}

- (void)removeButtonClicked:(id)sender
{
    [self displayInsetViewController:nil];
}

- (void)hideWithModalButtonClicked:(id)sender
{
    MemoryWarningTestCoverViewController *memoryWarningTestViewController = [[[MemoryWarningTestCoverViewController alloc] init] autorelease];
    [self presentModalViewController:memoryWarningTestViewController animated:YES];
}

- (void)orientationClonerButtonClicked:(id)sender
{
    OrientationClonerViewController *orientationClonerViewController = [[[OrientationClonerViewController alloc] 
                                                                         initWithPortraitOrientation:UIInterfaceOrientationIsPortrait(self.interfaceOrientation)
                                                                         large:NO]
                                                                        autorelease];
    [self displayInsetViewController:orientationClonerViewController];
}

- (void)containerCustomizationButtonClicked:(id)sender
{
    ContainerCustomizationViewController *containerCustomizationViewController = [[[ContainerCustomizationViewController alloc] init] autorelease];
    [self displayInsetViewController:containerCustomizationViewController];
}

- (void)stretchingContentSwitchValueChanged:(id)sender
{
    self.stretchingContent = self.stretchingContentSwitch.on;
}

- (void)forwardingPropertiesSwitchValueChanged:(id)sender
{
    self.forwardingProperties = self.forwardingPropertiesSwitch.on;
}

#pragma mark UIPickerViewDataSource protocol implementation

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return HLSTransitionStyleEnumSize;
}

#pragma mark UIPickerViewDelegate protocol implementation

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case HLSTransitionStyleNone: {
            return @"HLSTransitionStyleNone";
            break;
        }
            
        case HLSTransitionStyleCoverFromBottom: {
            return @"HLSTransitionStyleCoverFromBottom";
            break;
        }
            
        case HLSTransitionStyleCoverFromTop: {
            return @"HLSTransitionStyleCoverFromTop";
            break;
        }
            
        case HLSTransitionStyleCoverFromLeft: {
            return @"HLSTransitionStyleCoverFromLeft";
            break;
        }
            
        case HLSTransitionStyleCoverFromRight: {
            return @"HLSTransitionStyleCoverFromRight";
            break;
        }
            
        case HLSTransitionStyleCoverFromTopLeft: {
            return @"HLSTransitionStyleCoverFromTopLeft";
            break;
        }
            
        case HLSTransitionStyleCoverFromTopRight: {
            return @"HLSTransitionStyleCoverFromTopRight";
            break;
        }
            
        case HLSTransitionStyleCoverFromBottomLeft: {
            return @"HLSTransitionStyleCoverFromBottomLeft";
            break;
        }
            
        case HLSTransitionStyleCoverFromBottomRight: {
            return @"HLSTransitionStyleCoverFromBottomRight";
            break;
        }
            
        case HLSTransitionStyleFadeIn: {
            return @"HLSTransitionStyleFadeIn";
            break;
        }
            
        case HLSTransitionStyleCrossDissolve: {
            return @"HLSTransitionStyleCrossDissolve";
            break;
        }
            
        case HLSTransitionStylePushFromBottom: {
            return @"HLSTransitionStylePushFromBottom";
            break;
        }
            
        case HLSTransitionStylePushFromTop: {
            return @"HLSTransitionStylePushFromTop";
            break;
        }
            
        case HLSTransitionStylePushFromLeft: {
            return @"HLSTransitionStylePushFromLeft";
            break;
        }
            
        case HLSTransitionStylePushFromRight: {
            return @"HLSTransitionStylePushFromRight";
            break;
        }
            
        case HLSTransitionStyleEmergeFromCenter: {
            return @"HLSTransitionStyleEmergeFromCenter";
            break;
        }
            
        default: {
            return @"";
            break;
        }            
    }
}

#pragma mark Localization

- (void)localize
{
    [super localize];
    
    self.title = @"HLSPlaceholderViewController";
    [self.lifecycleTestSampleButton setTitle:NSLocalizedString(@"Lifecycle test", @"Lifecycle test") forState:UIControlStateNormal];
    [self.stretchableSampleButton setTitle:NSLocalizedString(@"Stretchable", @"Stretchable") forState:UIControlStateNormal];
    [self.fixedSizeSampleButton setTitle:NSLocalizedString(@"Fixed size", @"Fixed size") forState:UIControlStateNormal];
    [self.heavySampleButton setTitle:NSLocalizedString(@"Heavy view (cached)", @"Heavy view (cached)") forState:UIControlStateNormal];
    [self.portraitOnlyButton setTitle:NSLocalizedString(@"Portrait only", @"Portrait only") forState:UIControlStateNormal];
    [self.landscapeOnlyButton setTitle:NSLocalizedString(@"Landscape only", @"Landscape only") forState:UIControlStateNormal];
    [self.removeButton setTitle:NSLocalizedString(@"Remove", @"Remove") forState:UIControlStateNormal];
    [self.containerCustomizationButton setTitle:NSLocalizedString(@"Container customization", @"Container customization") forState:UIControlStateNormal];
    [self.hideWithModalButton setTitle:NSLocalizedString(@"Hide with modal", @"Hide with modal") forState:UIControlStateNormal];
    self.stretchingContentLabel.text = NSLocalizedString(@"Stretch content", @"Stretch content");
    self.forwardingPropertiesLabel.text = NSLocalizedString(@"Forwarding properties", @"Forwarding properties");
    self.transitionLabel.text = NSLocalizedString(@"Transition", @"Transition");
}

@end