//
//  MovieCell.h
//  Next-Flix
//
//  Created by Paula Leticia Geronimo on 6/25/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;


@end

NS_ASSUME_NONNULL_END
