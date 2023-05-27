#define STATUS_ITEM_VIEW_WIDTH_WITH_SECONDS 115.0
#define STATUS_ITEM_VIEW_WIDTH_NO_SECONDS 90.0

#pragma mark -

@class StatusItemView;

@interface MenubarController : NSObject {
@private
    StatusItemView *_statusItemView;
}

@property (nonatomic, assign) BOOL hasActiveIcon;

@end
