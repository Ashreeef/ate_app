import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/restaurant.dart';
import '../../repositories/restaurant_repository.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class RestaurantSelectionWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String? restaurantId, String restaurantName) onSelected;

  const RestaurantSelectionWidget({
    super.key,
    required this.controller,
    required this.onSelected,
  });

  @override
  State<RestaurantSelectionWidget> createState() => _RestaurantSelectionWidgetState();
}

class _RestaurantSelectionWidgetState extends State<RestaurantSelectionWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Restaurant> _suggestions = [];
  bool _isSearching = false;

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderBox();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: _suggestions.isEmpty
                  ? (_isSearching 
                      ? ListTile(title: Center(child: CircularProgressIndicator()))
                      : const SizedBox.shrink())
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final restaurant = _suggestions[index];
                        return ListTile(
                          leading: restaurant.imageUrl != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(restaurant.imageUrl!),
                                  radius: 16,
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.restaurant, size: 16),
                                  radius: 16,
                                ),
                          title: Text(restaurant.name),
                          subtitle: Text(restaurant.location ?? ''),
                          onTap: () {
                            widget.controller.text = restaurant.name;
                            widget.onSelected(restaurant.id, restaurant.name);
                            _hideOverlay();
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onChanged(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      _hideOverlay();
      widget.onSelected(null, query);
      return;
    }

    setState(() => _isSearching = true);
    if (_overlayEntry == null) _showOverlay();

    try {
      final restaurantRepo = context.read<RestaurantRepository>();
      final results = await restaurantRepo.searchRestaurants(query);
      
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
      
      // Rebuild overlay to show results
      _overlayEntry?.markNeedsBuild();
      widget.onSelected(null, query); // Inform parent about current text
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: _onChanged,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.restaurantHint,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLight),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(AppSpacing.md),
            prefixIcon: Icon(Icons.location_on, color: AppColors.textMedium),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }
}
extension on BuildContext {
  RenderBox findRenderBox() => findRenderObject() as RenderBox;
}
