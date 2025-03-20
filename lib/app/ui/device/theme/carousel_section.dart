import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inventoryplatform/app/controllers/carousel_section_controller.dart';
import 'package:inventoryplatform/app/data/models/departments_model.dart';

class CarouselSection extends StatelessWidget {
  final CarouselSectionController controller = Get.find<CarouselSectionController>();
  final bool? isExpanded;
  final String? route;

  CarouselSection({
    super.key,
    this.isExpanded,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    List<DepartmentsModel> departments = controller.getDepartments();
    controller.initializeHoverState(departments.length);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setHovered(controller.carouselIndex.value, true);
      Future.delayed(
        const Duration(seconds: 3),
        () => controller.setHovered(controller.carouselIndex.value, false),
      );
    });

    return  Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: (isExpanded ?? false)
                    ? MediaQuery.of(context).size.height * 0.75
                    : MediaQuery.of(context).size.height * 0.25,
                viewportFraction: 0.8,
                initialPage: 1,
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  controller.updateCarouselIndex(index);
                  controller.setHovered(index, true);
                  Future.delayed(
                    const Duration(seconds: 3),
                    () => controller.setHovered(index, false),
                  );
                },
              ),
              items: departments
                  .asMap()
                  .entries
                  .map(
                    (entry) => _buildCarouselItem(
                        entry.key, entry.value, 0.8, context,
                        route: route),
                  )
                  .toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                departments.length,
                (index) =>
                    _buildIndicator(controller.carouselIndex.value, index),
              ),
            ),
          ),
        ],
    );
  }

  Widget _buildCarouselItem(int index, DepartmentsModel department,
      double viewportfraction, BuildContext context,
      {String? route}) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Get.toNamed(
            route,
            arguments: department,
          );
        }
      },
      onLongPress: () {
        controller.setHovered(index, true);
        Future.delayed(
          const Duration(seconds: 3),
          () => controller.setHovered(index, false),
        );
      },
      child: MouseRegion(
        onEnter: (_) => controller.setHovered(index, true),
        onExit: (_) => controller.setHovered(index, false),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(145, 158, 158, 158),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: (department.imagePath != null)
                    ? Image.file(
                        File(department.imagePath!),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                    : const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                bottom: controller.isHoveredList[index] ? 0 : -40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: controller.isHoveredList[index] ? 1.0 : 0.0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      width: MediaQuery.of(context).size.width *
                          viewportfraction *
                          0.85,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            department.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: (isExpanded ?? false) ? 20 : 16,
                            ),
                          ),
                          if (department.description != null)
                            Text(
                              department.description!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (isExpanded ?? false) ? 16 : 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int currentIndex, int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index ? Colors.blue : Colors.grey.shade400,
      ),
    );
  }
}
