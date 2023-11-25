select *
from DataCleaning..NashvilleHousing

select SaleDateCoverted, CONVERT(Date, SaleDate)
from DataCleaning..NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

alter table NashvilleHousing
add SaleDateCoverted Date;

update NashvilleHousing
set SaleDateCoverted = CONVERT(Date, SaleDate);

------------------------------------------------------

select *
from DataCleaning..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select nashv1.ParcelID, nashv1.PropertyAddress, nashv2.ParcelID, nashv2.PropertyAddress, isnull(nashv1.PropertyAddress, nashv2.PropertyAddress)
from DataCleaning..NashvilleHousing nashv1
join DataCleaning..NashvilleHousing nashv2
	on nashv1.ParcelID = nashv2.ParcelID
	and nashv1.[UniqueID ] <> nashv2.[UniqueID ]
where nashv1.PropertyAddress is null;

update nashv1
set PropertyAddress = isnull(nashv1.PropertyAddress, nashv2.PropertyAddress)
from DataCleaning..NashvilleHousing nashv1
join DataCleaning..NashvilleHousing nashv2
	on nashv1.ParcelID = nashv2.ParcelID
	and nashv1.[UniqueID ] <> nashv2.[UniqueID ]
where nashv1.PropertyAddress is null;



select PropertyAddress
from DataCleaning..NashvilleHousing;

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from DataCleaning..NashvilleHousing;



alter table DataCleaning..NashvilleHousing
add PropertySplitAddress nvarchar(255);

update DataCleaning..NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table DataCleaning..NashvilleHousing
add PropertySplitCity nvarchar(255);

update DataCleaning..NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));

select *
from DataCleaning..NashvilleHousing;


select
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from DataCleaning..NashvilleHousing;

alter table DataCleaning..NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update DataCleaning..NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

alter table DataCleaning..NashvilleHousing
add OwnerSplitCity nvarchar(255);

update DataCleaning..NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

alter table DataCleaning..NashvilleHousing
add OwnerSplitState nvarchar(255);

update DataCleaning..NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)





select distinct(SoldAsVacant), count(SoldAsVacant)
from DataCleaning..NashvilleHousing
group by SoldAsVacant
order by 2;


select SoldAsVacant,
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
from DataCleaning..NashvilleHousing;

update DataCleaning..NashvilleHousing
set SoldAsVacant = 
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end





select *,
	ROW_NUMBER() over (
	partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID)
from DataCleaning..NashvilleHousing;